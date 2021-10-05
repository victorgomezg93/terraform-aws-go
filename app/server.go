package main

import (
  "fmt"
  "log"
  "net/http"
  "time"
  "context"
  "database/sql"
  "github.com/alexliesenfeld/health"
  _ "github.com/mattn/go-sqlite3"
)

func appHandler(w http.ResponseWriter, r *http.Request) {

  fmt.Println(time.Now(), "Hello from my new fresh server")

}

func main() {

 db, _ := sql.Open("sqlite3", "simple.sqlite")
  defer db.Close()

  // Create a new Checker.
  checker := health.NewChecker(

    // Set the time-to-live for our cache to 1 second (default).
    health.WithCacheDuration(1*time.Second),

    // Configure a global timeout that will be applied to all checks.
    health.WithTimeout(10*time.Second),

    // A check configuration to see if our database connection is up.
    // The check function will be executed for each HTTP request.
    health.WithCheck(health.Check{
      Name:    "database",      // A unique check name.
      Timeout: 2 * time.Second, // A check specific timeout.
      Check:   db.PingContext,
    }),

    // The following check will be executed periodically every 15 seconds
    // started with an initial delay of 3 seconds. The check function will NOT
    // be executed for each HTTP request.
    health.WithPeriodicCheck(15*time.Second, 3*time.Second, health.Check{
      Name: "search",
      // The check function checks the health of a component. If an error is
      // returned, the component is considered unavailable (or "down").
      // The context contains a deadline according to the configured timeouts.
      Check: func(ctx context.Context) error {
        return fmt.Errorf("this makes the check fail")
      },
    }),

    // Set a status listener that will be invoked when the health status changes.
    // More powerful hooks are also available (see docs).
    health.WithStatusListener(func(ctx context.Context, state health.CheckerState) {
      log.Println(fmt.Sprintf("health status changed to %s", state.Status))
    }),
  )



  http.HandleFunc("/", appHandler)
  http.Handle("/health", health.NewHandler(checker))

  
  s := &http.Server{
    Addr: ":443",
    Handler: nil, // use `http.DefaultServeMux`
  }

  log.Println("Started, serving on port 443")
  err := s.ListenAndServeTLS("public.crt", "private.key")
  //log.Println("Started, serving on port 8080")
  //err := s.ListenAndServe()

  if err != nil {
    log.Fatal(err.Error())
  }
}