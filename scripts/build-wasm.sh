#!/usr/bin/env bash


echo -e "⚙️ Building wasm file...\n"

mlc_llm compile ./mlc-chat-config.json --device webgpu -o llama3.wasm