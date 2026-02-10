# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# install custom nodes into comfyui (first node with --mode remote to fetch updated cache)
RUN comfy node install --exit-on-fail rgthree-comfy@1.0.2512112053 --mode remote
RUN comfy node install --exit-on-fail seedvr2_videoupscaler@2.5.24

# download models into comfyui
RUN comfy model download --url https://huggingface.co/cmeka/SeedVR2-GGUF/blob/main/seedvr2_ema_7b_sharp-Q4_K_M.gguf --relative-path models/checkpoints --filename seedvr2_ema_7b_sharp-Q4_K_M.gguf
RUN comfy model download --url https://huggingface.co/numz/SeedVR2_comfyUI/blob/main/ema_vae_fp16.safetensors --relative-path models/vae --filename ema_vae_fp16.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
