# GitHub Pipeline Secrets Management Issue

## Current Situation

We have a separation between our application code and pipeline infrastructure:
- **App_repo (WebGoat, JuiceShop)**: Contains client application code
- **Github-Pipeline**: Contains pipeline definitions and build logic

The current challenge involves GitHub secrets management because:
- Pipeline workflows from Github-Pipeline are triggered by App_repo
- GitHub secrets are repository-scoped
- App_repo cannot access Github-Pipeline's secrets, and vice versa

## Current Solution

As a temporary workaround, we're storing secrets in App_repo's GitHub secrets storage. While this works, it presents some challenges:
- Security concerns (secrets stored in application repo)
- Management overhead (duplication when same secrets are needed elsewhere)
- Limited access control (all contributors with write access can potentially use these secrets)

## Alternative Secure Secret Storage Options

### 1. Secrets Manager/Parameter Store
- Store secrets in any managed service
- Access via integration in GitHub Actions

### 2. Dedicated Secrets Repository
- Create private repo3 just for secrets
- Use GitHub Actions to request secrets via API
- Tightly control access to repo3

### 3. GitHub Organization-Level Secrets
- If both repos are in same org
- Create organization-wide secrets
- Restrict which repositories can access them
