
## Why Dynamic Outputs Can't Be Used Across Jobs in GitHub Actions

GitHub Actions does not currently support dynamic outputs being shared directly between different jobs. This limitation exists because outputs between jobs must be defined at workflow compile time, not at runtime.

### Key Points

- **Static Outputs Required**: Job outputs must be statically declared using `outputs` in the job definition and set using `echo "var=${{ var }}" >> $GITHUB_OUTPUT"`. These outputs are resolved when the workflow graph is created — *before* any job starts executing.
  
- **Workaround: Artifacts or External Storage**: If dynamic data needs to be passed between jobs, use intermediate storage mechanisms:
  - **Artifacts**: Upload a file in one job and download it in another.
  - **Caching**: Store dynamic content in the cache and restore it later.

https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/passing-information-between-jobs
