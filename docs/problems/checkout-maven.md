# Reduce Maven
## First Approach
When we set out to reduce the verbosity of the maven-dependencies job, our initial approach involved migrating its logic to a composite GitHub Action. This strategy aimed to encapsulate the steps, making the job definition cleaner and more reusable.

![Current workflow](/docs/assets/maven-checkout/maven-dependencies.png)
![Current workflow](/docs/assets/maven-checkout/composite.png)

However, during the implementation of the composite action, we encountered a persistent permissions error. 
![Current workflow](/docs/assets/errors/permissionError.png)

After investigation, we determined that the action required elevated privileges to execute certain commands, leading us to a temporary resolution: running the action as the root user.

While this approach resolved the immediate error, it presented a significant security vulnerability. Granting root access to a GitHub Action is not a secure practice and goes against our principle of least privilege. Consequently, we reverted to the previous, more verbose, but secure implementation of the maven-dependencies job.

## Second Approach
We've adopted a new strategy that successfully addresses the previous permissions concerns and enhances reusability. Instead of directly embedding the logic within the job, we've created a dedicated maven.yml  file. This file encapsulates the necessary steps for Maven operations, ensuring that all permissions are handled within its scope or eliminating the root user requirement we previously faced.

The maven.yml workflow is designed to be highly modular. It first performs a checkout of the repository, and then it calls a composite GitHub Action to execute the core Maven commands. This composite action centralizes the Maven execution logic, making it a single source of truth for all Maven-related tasks while in the main workflow we have:
![Current workflow](/docs/assets/maven-checkout/maven-final.png)