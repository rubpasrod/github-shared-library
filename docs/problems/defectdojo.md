## How DefectDojo Works in the Pipeline

### DefectDojo Structure

DefectDojo is a security vulnerability management system that organizes information through a hierarchy of objects:

- **Product**: Represents a specific application or system.
- **Engagement**: A time-bounded testing period under a product. Each scan/report is linked to an engagement.
- **Test**: A scan or assessment run under an engagement.
- **Finding**: A vulnerability or issue detected in a test.

---

### Creating the Engagement and Storing the Engagement ID

In the workflow, an engagement is either fetched or created dynamically using a shell script (`create-engagement.sh`). This is handled by the `create-engagement` job.

The script works as follows:

1. **Check if the engagement already exists**:
   - A GET request is made to the DefectDojo API using the engagement name.
   - If found, it returns the existing `engagement_id`.

2. **Create the engagement if it doesn't exist**:
   - A POST request is sent to the API with details like `name`, `product`, `target_start`, `target_end`, and `status`.
   - The returned `engagement_id` is captured.

This ID is then set as a job output using:
```bash
echo "engagement_id=$ENGAGEMENT_ID" >> $GITHUB_OUTPUT
```

---

### Uploading Reports: Import vs. Reimport

Once the engagement is available, the `upload-scans` job takes care of uploading the scan reports. This is done through the `upload-scan.sh` script, which automates the logic for handling both **new scan imports** and **reimports** when a scan type already exists for the engagement.

The process works as follows:

1. **Read Input Files**:
   - The script reads two files from a predefined directory (`REPORTS_DIR`):
     - `report_names.txt`: contains the filenames of the reports to upload.
     - `scan_types.txt`: contains the scan type corresponding to each report (e.g., "TruffleHog Scan", "Semgrep Scan").

   These files are paired line by line using the `paste` command to process each scan type with its corresponding report file.

2. **Check for Existing Test**:
   - For each scan type, the script checks whether a test of that type already exists in the engagement by making a `GET` request to:
     ```bash
     $BASE_URL/api/v2/tests/?engagement=$ENGAGEMENT_ID
     ```
   - It uses `jq` to filter results based on the `test_type_name` (scan type).

3. **Decide Between Import or Reimport**:
   - **If a test already exists** (i.e., scan type is already present for the engagement):
     - The script calls the `reimport-scan`.
     - This updates the existing test with the new findings.

   - **If no test exists yet** for that scan type:
     - The script uses the `import-scan` endpoint to create a new test.

4. **Upload Completion**:
   - The script outputs a message after each upload indicating whether the scan was imported or reimported successfully.

This logic ensures that:
- Scans are not duplicated in the same engagement.
- Existing scans can be updated easily.
- All findings are correctly attributed to their respective scan types and engagement context.
