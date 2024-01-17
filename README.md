# Trivy
GitHub composite action to run Trivy scans on Docker images, and project's file systems.

## Usage
```yaml
    steps:
    - name: Build Docker Image
      id: docker_build
      uses: docker/build-push-action@v3
      with:
        push: false
        tags: user/app:latest

    - name: Trivy Scan
      uses: hpe-actions/trivy@<RELEASE>
      with:
        imageid: ${{ steps.docker_build.outputs.imageid }}
```
## Trivy Vulnerability Issues
Ignoring Trivy vulnerability issues should be a last resort only used when
released software hasn't been patched yet. Best practices include adding a
comment why the CVEs were added to the ignore file and for what version so they
can be fixed or removed at a later date.

Include a `.trivyignore` file in the root of the repository to ignore
vulnerabilities that can't be fixed. Use `.trivyignore` sparingly and update it
when vulnerabilites are fixed. Below is an example:
```bash
# Added for vulnerability found in foo-bar v1.2, remove when fix is released
CVE-2022-12345
CVE-2022-67890
```
## Trivy Secrets Issues
Any secrets Trivy discovered should be analyzed to determine how to proceed. If
it is determined the secret found is okay to stay in the repository then create
a rule in a `trivy-secret.yaml` file in the root of the repository.

```yaml
allow-rules:
  - id: fake-secret
    description: Allow a fake secret in script
    path: \/fake-secret.sh
```

Further documentation on configuring the `trivy-secret.yaml` file can be found
on Trivy's site (current docs [here](https://aquasecurity.github.io/trivy/v0.30.4/docs/secret/configuration/)).
Be sure to match the version of the docs with the Trivy version used by this
action.

## Usage Example With Custom Ignore Policy
```yaml
    - name: Trivy Scan
      uses: hpe-actions/trivy@<RELEASE>
      with:
        imageid: ${{ steps.docker_build.outputs.imageid }}
        ignore_policy: ignore-policy.rego
```

Where `ignore-policy.rego` can look something like this and is located at the root of the repository:
```opa
package trivy

default ignore = false
ignore_cves := {"CVE-2017-11468", "CVE-2019-16884", "CVE-2019-19921"}
ignore {
    input.VulnerabilityID = ignore_cves[_]
}
```

## Inputs
```yaml
  imageid:
    required: true
    description: Image ID of docker image to scan (imageid output from docker/build-push-action)
    type: string

  trivyignores:
    required: false
    description: "comma-separated list of relative paths in repository to one or
      more .trivyignore files. `.trivyignore` is used if this is left blank.
      See https://github.com/aquasecurity/trivy-action for more information."
    type: string
    default: ""

  ignore_policy:
    required: false
    description: Path of trivy ignore policy file
    type: string
    default: ""

  skip-dirs:
    description: 'comma separated list of directories where traversal is skipped'
    required: false
    default: ''

  skip-files:
    description: 'comma separated list of files to be skipped'
    required: false
    default: ''

  skip-fs-scan:
    description: 'skip file system scan'
    required: false
    default: false

  security_checks:
    required: false
    description: "Comma-separated list of what security issues to detect.
      See https://github.com/aquasecurity/trivy-action#inputs for more
      information."
    type: string
    default: ""
```
