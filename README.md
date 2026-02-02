# krankerl-builder

A minimal Docker image to package **Nextcloud apps** using [`krankerl`](https://github.com/ChristophWurst/krankerl).

It supports:

* running on an **existing git repository** (mounted)
* **cloning a GitHub repository** (optionally specifying a branch)
* running as **non-root user (UID/GID 1000:1000)**
* exporting build artifacts to a mounted directory

## Build the image

```bash
docker build -t krankerl-builder .
```

## Usage

### 1. Use the current directory (already a git repo)

```bash
mkdir -p output

docker run --rm \
  --mount type=bind,source="$(pwd)",target=/workspace \
  --mount type=bind,source="$(pwd)/output",target=/opt/build \
  krankerl-builder
```

### 2. Clone a GitHub repository (default branch)

```bash
mkdir -p output

docker run --rm \
  --mount type=bind,source="$(pwd)/output",target=/opt/build \
  krankerl-builder \
  https://github.com/OWNER/REPO.git
```

### 3. Clone a GitHub repository (specific branch)

```bash
mkdir -p output

docker run --rm \
  --mount type=bind,source="$(pwd)/output",target=/opt/build \
  krankerl-builder \
  https://github.com/OWNER/REPO.git \
  my-branch
```

## Output

If `krankerl package` succeeds, the build output is copied to:

```
/opt/build
```

On the host:

```
./output
└── artifacts/
   └── <app-name>.tar.gz
```

## Notes

* The container runs as **UID/GID 1000:1000**
* The `output` directory **must exist and be writable** by UID 1000
