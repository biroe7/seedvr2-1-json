# Usa a mesma imagem base que funcionou no seu Imagen-Z
FROM runpod/worker-comfyui:5.7.1-base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# --- DEPENDÊNCIAS DO SISTEMA ---
# O SeedVR2 exige bibliotecas de vídeo e processamento que o Imagen-Z não usava
RUN pip install sentencepiece protobuf pandas torchaudio

# Instala os nós customizados necessários para o SeedVR2
RUN comfy node install rgthree-comfy || true
RUN comfy node install seedvr2_videoupscaler || true

# Cria as pastas para organizar os modelos
RUN mkdir -p /comfyui/models/checkpoints
RUN mkdir -p /comfyui/models/vae

# --- DOWNLOADS (Links Diretos Corrigidos) ---

# 1. Modelo Principal SeedVR2 (GGUF)
# Corrigido de /blob/ para /resolve/ para o wget conseguir baixar
RUN wget -O /comfyui/models/checkpoints/seedvr2_ema_7b_sharp-Q4_K_M.gguf \
    "https://huggingface.co/cmeka/SeedVR2-GGUF/resolve/main/seedvr2_ema_7b_sharp-Q4_K_M.gguf"

# 2. VAE Específico para SeedVR2
# Corrigido para link de download direto
RUN wget -O /comfyui/models/vae/ema_vae_fp16.safetensors \
    "https://huggingface.co/numz/SeedVR2_comfyUI/resolve/main/ema_vae_fp16.safetensors"

# Define o caminho para o ComfyUI encontrar os modelos no RunPod
ENV COMFYUI_MODEL_PATH=/comfyui/models
