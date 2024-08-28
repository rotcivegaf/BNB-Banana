import { createWeb3Modal, defaultWagmiConfig } from '@web3modal/wagmi'
import { reconnect, getAccount } from '@wagmi/core'
import { get, writable, derived } from 'svelte/store';
import { bscTestnet, opBNBTestnet } from 'viem/chains';

// const projectId = import.meta.env.VITE_WEB3MODAL_PROJECT_ID;
const projectId = "619498c450ee42530036acb486570472";

// export const provider = writable();

export const modal = writable();
export const config = writable();
export const loadReady = writable(false);

export const account = writable('');

export function initWeb3() {

  // 2. Create wagmiConfig
  const metadata = {
    name: 'IdleBananaMiner',
    description: 'IdleBananaMiner',
    url: 'https://IdleBananaMiner.com/', // origin must match your domain & subdomain
    icons: ['https://avatars.githubusercontent.com/u/37784886']
  }

  const _config = defaultWagmiConfig({
    chains: [bscTestnet, opBNBTestnet], // required
    projectId, // required
    metadata, // required
    ssr:false,
    // transports: ['http', 'ws'], // Optional - defaults to ['http', 'ws']
    // ...wagmiOptions // Optional - Override createConfig parameters
  })

  // 3. Create modal
  const _modal = createWeb3Modal({
    wagmiConfig: _config,
    projectId,
    enableAnalytics: true // Optional - defaults to your Cloud configuration
  });

  _modal.subscribeState(stateData => {
    // lets set the ready after we have the selected network
    loadReady.set(true);

    const dataAccount  = getAccount(_config);
    if (dataAccount && dataAccount.address) {
      account.set(dataAccount.address);
    }
  });

  reconnect(_config);

  modal.set(_modal);
  config.set(_config);

}

export const chainId = derived(modal, $modal => {
  if(!$modal) return 0;
  try {
    return $modal.getState().selectedNetworkId;
  } catch (e) {
    return 0;
  }
});


export function getBananaAddr() {
  if(get(config).state.chainId == bscTestnet.id) // bscTestnet
    return '0x0305768b3c1d0919a94b121E77153888C55d1326';
  else if(get(config).state.chainId == opBNBTestnet.id) // opBNBTestnet
    return '';
  else 
    throw new Error("Wrong chain");    
} 