# Meta-Llama-3-8B-Instruct

## What

This is a fork of [Llama-3-8B-Instruct-q4f16_1-MLC](https://huggingface.co/mlc-ai/Llama-3-8B-Instruct-q4f16_1-MLC)

## Why

HuggingFace.co may be blocked in your corporate network.

This fork aims to:

- store the model in Github instead (without using GitLFS)
- provide a prebuilt Wasm file (to load with WebLLM) 

## How

Instructions on how-to build Wasm file for WebLLM (on MacOs)

### Emscripten

```bash
## Install emscripten. See: https://emscripten.org/docs/getting_started/downloads.html
# Get the emsdk repo
git clone https://github.com/emscripten-core/emsdk.git

# Enter that directory
cd emsdk

# Fetch the latest version of the emsdk (not needed the first time you clone)
git pull

# Download and install the latest SDK tools.
./emsdk install latest

# Make the "latest" SDK "active" for the current user. (writes .emscripten file)
./emsdk activate latest

# Activate PATH and other environment variables in the current terminal
# You can also put these below lines into .zshrc
source ./emsdk_env.sh
# OR
export EMSDK=/Users/anhld/Works/code/oss/llm/emsdk
export EMSDK_NODE=/Users/anhld/Works/code/oss/llm/emsdk/node/16.20.0_64bit/bin/node
export EMSDK_PYTHON=/Users/anhld/Works/code/oss/llm/emsdk/python/3.9.2_64bit/bin/python3
export SSL_CERT_FILE=/Users/anhld/Works/code/oss/llm/emsdk/python/3.9.2_64bit/lib/python3.9/site-packages/certifi/cacert.pem
export PATH=$EMSDK/upstream/emscripten:$PATH

# Validate that emcc is accessible in shell
emcc --version
```

### MLC LLM

```bash
# See: https://llm.mlc.ai/docs/install/mlc_llm.html#option-1-prebuilt-package
brew install --cask anaconda
conda init zsh
conda create --name  dev
conda activate dev
python3 -m pip install --pre -U -f https://mlc.ai/wheels mlc-llm-nightly mlc-ai-nightly

# verify
python -c "import mlc_llm; print(mlc_llm)"
# Prints out: <module 'mlc_llm' from '/path-to-env/lib/python3.11/site-packages/mlc_llm/__init__.py'>

# you can put this alias in .zshrc
alias mlc_llm="python -m mlc_llm"
```

To compile model libraries for webgpu, you need to build mlc_llm from source. Besides, you also need to follow Install Wasm Build Environment. (see [guide](https://llm.mlc.ai/docs/deploy/javascript.html#try-out-the-prebuilt-webpage))

```bash
git clone https://github.com/mlc-ai/mlc-llm.git --recursive
cd mlc-llm
export MLC_LLM_HOME=$(pwd)
export TVM_HOME=$MLC_LLM_HOME/3rdparty/tvm
./web/prep_emcc_deps.sh
```

### Llama3

```bash
git clone https://huggingface.co/mlc-ai/Llama-3-8B-Instruct-q4f16_1-MLC

# verify TVM_HOME, MLC_LLM_HOME
echo $TVM_HOME
echo $MLC_LLM_HOME

mlc_llm compile ./mlc-chat-config.json --device webgpu -o llama3.wasm
```

### Serve

If you want to serve to model locally (with CORS disabled)

```bash
$ go run ./scripts/server.go
Starting server on port 8080
```

## Github LFS

To bypass LFS, we can re-shard:

```bash
$ ./scripts/partition.sh
```

You then see in [](./ndarray-cache.json) we may have query parameters for `dataPath`:

```json
{
    "records": [
        {
            "dataPath": "params_shard_0.bin?partitions=4",
            "format": "raw-shard",
            "nbytes": 262668288,
            "records": [
                {
                    "name": "lm_head.q_weight",
                    "shape": [
                        128256,
                        512
                    ],
                    "dtype": "uint32",
                    "format": "f32-to-bf16",
                    "nbytes": 262668288,
                    "byteOffset": 0
                }
            ],
            "md5sum": "96d80a43175f832669b92448d48d7854"
        }
    ]
}
```
