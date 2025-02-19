#!/bin/bash

IN_FILE="articles/ai-agent-research-2025-2.md "
OUT_FILE="articles/ai-agent-research-2025-2-mod.md "
TMP_FILE="tmp.txt"

# Using sed to find and replace the pattern
sed 's/ *\[\([^]]*\)\](\([^)]*\)) */[[\1]](\2)/g' ${IN_FILE} > ${OUT_FILE}

# rm ${TMP_FILE}
