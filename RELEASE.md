# Release Documentation

This document describes the release process for BillionMail.

## Versioning Strategy

BillionMail follows [Semantic Versioning](https://semver.org/) (SemVer):

- **MAJOR.MINOR.PATCH** (e.g., v1.2.3)
  - **MAJOR**: Incompatible API changes or major new features
  - **MINOR**: New functionality in a backward-compatible manner
  - **PATCH**: Backward-compatible bug fixes

## How to Create a New Release

### Step 1: Prepare the Release

1. Ensure all changes for the release are merged to the appropriate branch
2. Update documentation if needed
3. Test the build thoroughly

### Step 2: Create a Release Tag

You can create a release tag in two ways:

#### Option A: Using the GitHub Actions Workflow (Recommended)

1. Go to the [Actions tab](https://github.com/enzorobot07/BillionMail/actions)
2. Select the "Create Release Tag" workflow
3. Click "Run workflow"
4. Enter the tag name (e.g., `v1.0.0`) and optional message
5. Click "Run workflow" to create and push the tag

#### Option B: Using Git Command Line

```bash
# Create an annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push the tag to trigger the release
git push origin v1.0.0
```

### Step 3: Automatic Release Creation

When a tag starting with `v` is pushed:

1. The [release workflow](/.github/workflows/release.yml) is automatically triggered
2. The workflow builds binaries for:
   - Linux AMD64 (x86_64)
   - Linux ARM64
3. A GitHub release is created with:
   - The binaries attached as downloadable assets
   - Automatically generated release notes
   - The tag version as the release name

### Step 4: Verify the Release

1. Check the [Actions tab](https://github.com/enzorobot07/BillionMail/actions) to ensure the workflow completed successfully
2. Visit the [Releases page](https://github.com/enzorobot07/BillionMail/releases) to verify the release was created
3. Download and test the binaries to ensure they work correctly

## Release Checklist

Before creating a release, ensure:

- [ ] All planned features/fixes are merged
- [ ] Documentation is up to date
- [ ] Code has been tested
- [ ] Version number follows semantic versioning
- [ ] CHANGELOG or release notes are prepared (if applicable)

## Continuous Builds

In addition to versioned releases, the repository automatically builds binaries on every push to `dev` or `main` branches. These builds are available as:

- GitHub Actions artifacts (retained for 90 days)
- A "Latest Build" release for quick access to the most recent version

## Links

- [Releases Page](https://github.com/enzorobot07/BillionMail/releases)
- [Release Workflow](/.github/workflows/release.yml)
- [Create Tag Workflow](/.github/workflows/create-tag.yml)
- [Build Workflow](/.github/workflows/build-core.yml)

## Troubleshooting

### Tag Already Exists

If you try to create a tag that already exists, the workflow will fail. To fix:
- Delete the existing tag: `git tag -d v1.0.0 && git push origin :refs/tags/v1.0.0`
- Create the tag with a different version number

### Build Fails

If the release build fails:
1. Check the [Actions tab](https://github.com/enzorobot07/BillionMail/actions) for error logs
2. Ensure the Go code compiles locally: `cd core && go build`
3. Fix any issues and create a new tag with an incremented version

### Release Not Created

If the workflow runs but no release appears:
1. Verify the tag name starts with `v` (e.g., `v1.0.0`, not `1.0.0`)
2. Check the workflow logs for permission errors
3. Ensure the repository has the necessary permissions for GitHub Actions
