# GitHub Pipeline Wiki
## [How to use the pipeline](./docs/user_guide/how_to.md)
## Problems
### [1. Architecture](./docs/problems/architecture.md)
### [2. Nested Loops](./docs/problems/nested_loops.md)
### [3. Composite Actions](./docs/problems/composite_actions.md)
### [4. If/needs](./docs/problems/ifneeds.md)
### [5. DefectDojo](./docs/problems/defectdojo.md)
### [6. Secrets](./docs/problems/secrets.md)
### [7. Dynamic Outputs](./docs/problems/dynamic-outputs.md)
### [8. Variables](./docs/problems/variables.md)
### [9. Checkout Maven](./docs/problems/checkout-maven.md)
### [10. Reducing Code Length](./docs/problems/reducing-code-length.md)
### [11. Runners](./docs/problems/runner.md)

## Project Structure
```plaintext
.
├── .github
│   ├── workflows
│   │   ├── build.yml
│   │   ├── main.yml
│   │   ├── preflight.yml
│   │   ├── test.yml
│   │   └── unified-template.yml
│   └── workflows-lib
│       ├── core
│       │   ├── build-scripts
│       │   │   └── action.yml
│       │   ├── defect_dojo_upload
│       │   │   └── action.yml
│       │   ├── load_all_variables
│       │   │   └── action.yml
│       │   ├── managers\run-template
│       │   │   └── action.yml
│       │   └── node
│       ├── docker\docker-build 
│       │   └── action.yml
│       └──security\template       
│           └── action.yml
│   
├── config
│   └── toolname-default.config
│
├── scripts
    └── defectdojo
        ├── create-engagement.sh
        └── upload-scan.sh
```
## Current workflow
![Current workflow](/docs/assets/design/workflow_example.png)

## Adding a new tool
To add a new tool to the pipeline, follow these two main steps:

1. Add the Tool Environment File
Place the environment file for the new tool into the config folder. We are using as .config file name: tool-default.config.

For example, if the new tool is named mytool, you would add a file like this:
```plaintext
.
├── ...
├── config
│   ├── existing_tool-default.config
│   └── mytool-default.config  <-- Add your new tool's config file here
├── ...
```

2. Add the New Tool to the Pipeline
To integrate a new tool into the workflow, you must define it as a new job within the relevant GitHub Actions workflow file (currently .github/workflows/preflight.yml). This new job will fetch its configuration dynamically and execute the tool.

### Example: Adding a newTool Job
```yaml
  static-tools:
    name: Tool
    needs: 
      - load-all
      - security-gate
      - build-scripts
    runs-on: self-hosted
    strategy:
      matrix:
        tool: [trufflehog, gitleaks, semgrep, checkov, dependency-check, kics] # Add the tool name here
    container:
      image: ${{ fromJson(needs.build-scripts.outputs.config)[matrix.tool].IMAGE }} 
      options: --entrypoint "" 
    steps:
      - name: Prepare REPORTS_DIR
        id: check_enabled
        run: |
          ENABLED=${{ fromJson(needs.build-scripts.outputs.config)[matrix.tool].ENABLED_SEC_TOOL }}
          echo "enabled=$ENABLED" >> $GITHUB_OUTPUT

      - name: Run tool
        if: ${{ steps.check_enabled.outputs.enabled == 'true' }}  
        uses: ./github-pipeline/.github/workflows-lib/security/template
        with: 
          script: "${{ fromJson(needs.build-scripts.outputs.config)[matrix.tool].SCRIPT }}"
          report_name: "${{ fromJson(needs.build-scripts.outputs.config)[matrix.tool].JOB_NAME }}.${{ fromJson(needs.build-scripts.outputs.config)[matrix.tool].FORMAT }}"
          scan_type: "${{ fromJson(needs.build-scripts.outputs.config)[matrix.tool].SCAN_TYPE }}"
        continue-on-error: true
```

# 🛣️ Roadmap
![Roadmap](/docs/assets/roadmap/roadmap.png)
