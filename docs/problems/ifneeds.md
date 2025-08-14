## GitHub Actions: Usage of `needs`, `if`, and Handling Dependencies

### How `needs` and `if` Work in GitHub Actions

In GitHub Actions, the `needs` keyword is used to define job dependencies. It ensures that a job only runs after the jobs it "needs" have completed successfully. When a job uses `needs`, it can also access the `outputs` of those jobs.

The `if` keyword is used to conditionally run steps or jobs. It can be based on the outputs from other jobs (if `needs` is used), step results, secrets, environment variables, etc.

#### Limitation:
A key limitation in GitHub Actions is that **you can only access the outputs of another job if you declare it using `needs`**. Without `needs`, attempting to use outputs from another job will not work and will result in an error during workflow evaluation.

---

### Node and Maven Dependencies with Conditional Execution and Security Gate

In this pipeline, two jobs—`node-dependencies` and `maven-dependencies`—are conditionally executed based on values provided by the `load-variables` job. These values indicate whether each tool (Node or Maven) should be enabled.

Each job uses a pattern like this:
- A first step checks whether the tool should run (using `if` and job outputs).
- If the tool is not enabled, it outputs a `skip=true` flag and avoids running the remaining steps.
- If the tool is enabled, it checks out the relevant repositories and runs the dependency installation.


