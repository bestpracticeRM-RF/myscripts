#!/bin/bash

# Проверяем, что указан удаленный хост
if [ -z "$1" ]; then
    echo "Использование: $0 <удаленный_хост>"
    exit 1
fi

REMOTE_HOST=$1
ANSIBLE_USER="ansible"
LOCAL_KEY="${HOME}/.ssh/id_ed25519.pub"

# Проверяем наличие локального SSH-ключа
if [ ! -f "$LOCAL_KEY" ]; then
    echo "Ошибка: Файл $LOCAL_KEY не найден."
    exit 1
fi

# Читаем содержимое публичного ключа
PUBLIC_KEY=$(cat "$LOCAL_KEY")

# Копируем ключ на удаленный хост
echo "Копирование SSH-ключа на $REMOTE_HOST..."
ssh "$REMOTE_HOST" "mkdir -p ~/.ssh && chmod 700 ~/.ssh" || { echo "Не удалось создать директорию ~/.ssh"; exit 1; }
ssh "$REMOTE_HOST" "echo '$PUBLIC_KEY' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys" || { echo "Не удалось добавить ключ в authorized_keys"; exit 1; }

echo "SSH-ключ успешно скопирован на $REMOTE_HOST."
