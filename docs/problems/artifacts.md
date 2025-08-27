# GitHub Actions Error: Artifact Storage Quota Exceeded

When running GitHub Actions workflows, it may show the following error:
![artifacts](/docs/assets/errors/artifacts.png)


## What This Means
This error occurs because the storage allocated for GitHub Actions artifacts has reached its limit. Once the quota is exceeded, no new artifacts can be uploaded until space is freed or the quota resets.

## Key Details
- **Cause**: The GitHub repository or organization has exceeded its artifact storage quota.  
- **Recalculation Window**: GitHub recalculates storage usage every **6–12 hours**. Sadly, This recalculation does not work as it should.
- **Impact**: No new workflow artifacts can be uploaded until the quota drops below the limit.

## How to Fix It
1. **Delete Old Artifacts**: Manually remove unnecessary artifacts from the repository.  
2. **Reduce Artifact Retention**: Adjust artifact retention policies in the workflow files to keep them for fewer days.  
   Example:
   ```yaml
   - name: Upload artifact
     uses: actions/upload-artifact@v3
     with:
       name: my-artifact
       path: ./output
       retention-days: 3
   ``` 
3. **Wait for Reset**: If immediate cleanup isn’t possible, wait until GitHub recalculates usage.

## Key Problem
GitHub Actions artifact storage is directly tied to the billing usage. If the repository or organization exceeds its storage quota, you will not be able to upload any new artifacts. Unlike workflow minutes, artifact storage does not reset daily; instead, it is tied to your billing cycle.

This means that if you’ve reached the storage quota, you may be blocked from uploading artifacts until:

- You delete existing artifacts to free up space.

- The next billing date arrives, which resets your available storage.

As a result, exceeding the quota can block artifact uploads for an extended period of time if cleanup is not performed. 

If artifact storage is critical for your workflows, you may need to either manage retention more aggressively.

## References
- [GitHub Documentation: Billing for GitHub Actions](https://docs.github.com/en/billing/managing-billing-for-github-actions/about-billing-for-github-actions#calculating-minute-and-storage-spending)
