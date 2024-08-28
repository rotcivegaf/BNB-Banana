import { config, getBananaAddr } from './store';
import { readContract, writeContract } from '@wagmi/core';
import { get } from 'svelte/store';

import { parseAbi } from 'viem'

const abi = parseAbi([
    'function minZeros() view returns (uint256)',
    'function usersHash(address user) view returns (bytes32)',
    'function mintBatch(address to, uint256[] nonces) external'
]);

export async function minZeros() {
    const data = await readContract(get(config), {
        address: getBananaAddr(),
        abi,
        functionName: 'minZeros',
        args: [],
        blockTag: 'latest',
    });

    return data;
}

export async function getSalt(user) {
    const data = await readContract(get(config), {
        address: getBananaAddr(),
        abi,
        functionName: 'usersHash',
        args: [user],
        blockTag: 'latest',
    });

    return data;
}

export async function mintBatch(user, nonces) {
    const data = await writeContract(get(config), {
        address: getBananaAddr(),
        abi,
        functionName: 'mintBatch',
        args: [user, nonces],
        //blockTag: 'latest',
    });

    return data;
}