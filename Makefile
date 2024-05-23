# Makefile for Lucky-Chain

# Variables
REPO_URL = https://github.com/Web3-Future/lucky-chain.git
DIR = contract

.PHONY: all clone install compile deploy clean

# Default target
all: clone install compile deploy

# Clone the repository
clone:
	git clone $(REPO_URL) $(DIR)

# Install dependencies
install:
	cd $(DIR) && forge install

# Compile the contracts
compile:
	cd $(DIR) && forge build

# Deploy the contracts
deploy:
	cd $(DIR) && forge script scripts/Deploy.s.sol:Deploy --rpc-url <your_rpc_url> --private-key <your_private_key>

# Clean the project
clean:
	cd $(DIR) && forge clean
