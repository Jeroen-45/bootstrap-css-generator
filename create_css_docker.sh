# Check if a file name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <file_name.scss>"
    exit 1
fi

# Check if input file is present
if [ ! -f "$1" ]; then
    echo "Input file $1 not found"
    exit 1
fi

# Get full path to the file
f=$(realpath "$1")

# Get base name of the file
fb=$(basename "$1" .scss)

# Run alpine in docker and create css files
echo "Starting docker container and installing dependencies in it..."
docker run -t -i --mount type=bind,src="$PWD",dst=/data --mount type=bind,src="$f",dst="/scss/$fb.scss" alpine /bin/ash -c "\
apk add --update curl npm && \
npm install -g sass postcss postcss-cli autoprefixer clean-css-cli && \
cd /data && \
./create_css.sh \"../scss/$fb.scss\""
