# Install node dependencies with:
# npm install sass postcss postcss-cli autoprefixer clean-css-cli

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

# Get base name of the file
f=$(basename "$1" .scss)

# Get bootstrap source code if it is not already present
cleanup_bootstrap=false
if [ ! -d "bootstrap" ]; then
    cleanup_bootstrap=true

    # Get most recent bootstrap release zipball link
    echo "Getting most recent bootstrap release zipball link..."
    download_url=$( curl -s https://api.github.com/repos/twbs/bootstrap/releases \
                    | grep -m 1 "zipball_url.*" \
                    | cut -d : -f 2,3 \
                    | tr -d \", )

    # Download it
    echo "Downloading bootstrap source code from $download_url"
    wget -O bootstrap.zip $download_url

    # Unzip it, rename the root folder to bootstrap, the cleanup the rest
    echo "Unzipping bootstrap.zip..."
    unzip -q -o bootstrap.zip -d bootstrap-tmp
    rm bootstrap.zip
    mkdir -p bootstrap
    mv bootstrap-tmp/*/* bootstrap
    rm -rf bootstrap-tmp
fi

# Build css from scss
echo "Building css from scss..."
npx sass --style expanded --no-source-map --no-error-css "$f.scss" "$f.css"

# Postprocess css to add browser specific prefixes
echo "Postprocessing css to add browser specific prefixes..."
npx postcss "$f.css" --use autoprefixer --config bootstrap/build/postcss.config.js -o "$f-prefixed.css"

# Minify css
echo "Minifying css..."
npx cleancss -O1 --format breakWith=lf --with-rebase -o "$f-prefixed.min.css" "$f-prefixed.css"

# Cleanup bootstrap source code if it was downloaded
if [ "$cleanup_bootstrap" = true ]; then
    echo "Cleaning up bootstrap source code..."
    rm -rf bootstrap
fi

# Done
echo "Done"