<script lang="ts">
    import { modal , account, loadReady} from '$lib/store';
    import {onMount} from 'svelte';
    import { minZeros, getSalt, mintBatch } from '$lib/contracts';

    let salt;
    let cores = 0;
    let coresSelected = 1;
    let difficulty; // get the start difficulty(leading zeros)

    onMount(async () => {
        difficulty = 6;
        coresSelected = parseInt(localStorage.getItem('cores') || '1');
        cores = Math.min(navigator.hardwareConcurrency, 10);
        window.mintBatch = mintBatch;
    })

    let minDif = "0";

    let items = {
        normal: [],
        steel: [],
        golden: [],
        crystal: [],
        mystic: [],
    };

    $: totalItems = Object.keys(items).reduce((total, w) => total + items[w].length, 0);
    $: allNonces = Object.keys(items).reduce((_nonces, e) => _nonces.concat(items[e]), []);

    function addItem(item) {
        let itemType;
        // count leading zeros in item.hash
        const leadingZeros = item.hashed.match(/^0+/)[0].length;
        if(Number(minDif) && leadingZeros < Number(minDif)) return;

        if (leadingZeros < difficulty) {
            console.log('Invalid hash', item.hashed);
            return;
        }else if (leadingZeros == difficulty) {
            console.log('Normal Banana', item.hashed);
            itemType = 'normal';
        }else if (leadingZeros == difficulty + 1) {
            console.log('Steel Banana', item.hashed);
            itemType = 'steel';
        }else if (leadingZeros == difficulty + 2) {
            console.log('Golden Banana', item.hashed);
            itemType = 'golden';
        }else if (leadingZeros == difficulty + 3) {
            console.log('Crystal Banana', item.hashed);
            itemType = 'crystal';
        }else {
            console.log('Mystic Banana', item.hashed);
            itemType = 'mystic';
        }

        items[itemType].push(item.nonce);
        items = {...items};

    }


    function coreAdd() {
        coresSelected = Math.min(coresSelected + 1, cores);
        localStorage.setItem('cores', coresSelected);
    }

    function coreSub() {
        coresSelected = Math.max(coresSelected - 1, 1);
        localStorage.setItem('cores', coresSelected);
    }

    let globalStatus = 'idle';
    let workers = [];

    let totalSpeed = 0;
    $: if (workers.length > 0 && workers[0].hashPerSecond > 0) {
		totalSpeed = workers.reduce((total, w) => total + w.hashPerSecond, 0);
    }

	let globalStart;
	let globalElapsed;
	let intervalCount;

    async function claim() {
        if(allNonces.length === 0) return;
        // @todo this not working as expect, i hack it using a form post
        doStop();
        resetItems();
        await mintBatch($account, allNonces.map(e => `0x${e}`).sort((a,b) => Number(BigInt(a)-BigInt(b))));
    }

	function doStop() {
		globalStatus = 'idle';
		workers.forEach((w) => {
			w.worker.terminate();
			w.status = 'stop';
		});
		workers = [...workers];
		if (intervalCount) clearInterval(intervalCount);
	}

	function terminateWorkers() {
		doStop();
		workers = [];
	}
    function resetItems() {
        items = {...{
        normal: [],
        steel: [],
        golden: [],
        crystal: [],
        mystic: [],
    }};

    }
	async function startMining() {
        if (globalStatus == 'mining') return;
		terminateWorkers();
		globalStatus = 'mining';
        let prevSalt = salt;
        salt = await getSalt($account);
        if (salt != prevSalt) {
            resetItems();
        }
		const cores = Math.min(coresSelected, Math.min(navigator.hardwareConcurrency, 20));

		globalStart = +new Date();
		intervalCount = setInterval(() => {
			globalElapsed = +new Date() - globalStart;
		}, 1000);

		for (let i = 0; i < cores; i++) {
			const worker = new Worker('/worker.js', { type: 'module' });
			workers[i] = { worker: worker, status: 'init', start: 0, end: 0, loops: 0, hashPerSecond: 0 };

			let time;

			worker.onmessage = function (event) {
				// console.log('Worker' + i, event.data.status);
				workers[i].status = event.data.status;

				workers[i].start = workers[i].start || Date.now();

				worker.onmessage = async function (event) {
                    console.log(event.data.results.length);
					if (event.data.results.length > 0) {

                        for (let j = 0; j < event.data.results.length; j++) {
                            addItem({
                                nonce: event.data.results[j][0],
                                hashed: event.data.results[j][1],
                            })
                        }

						//doStop();
						//clearInterval(intervalCount);
						//return;
					}
					workers[i].loops += 1;
					workers[i].hashPerSecond = Math.floor(
						(workers[i].loops * 100000) / ((Date.now() - workers[i].start) / 1000)
					);
					console.log('Worker' + i + ', hash/sec:', workers[i].hashPerSecond);
					workers[i].end = 0;

					// loop
					worker.postMessage({
						wallet: $account.slice(2),
						salt: salt && salt.slice(2),
						difficulty
					});
				};

				worker.postMessage({
					wallet: $account.slice(2),
					salt: salt && salt.slice(2),
					difficulty
				});
			};
		}
		workers = [...workers];
	}

</script>

<div class="container p-5">

    <h1 class="text-4xl">Mine your Banana!</h1>

    {#if $account == ''}
    <p class="text-sm max-w-screen-sm">
        Banana is an idle miner Game, in which you use your browser to get valid nonce
        to mine Banana! In Banana you use you luck and mining power to gain even more Banana!
        All the items you can claim will be grouped and you can claim them all at once.
    </p>
    <div class="pt-6">
        <p>To start:</p>
        <!--class:is-disabled={!$loadReady} disabled={!$loadReady}-->
        <button type="button" class="nes-btn is-primary"
         on:click={() => $modal.open({view: 'Connect'}) }>Connect your wallet</button>
    </div>
    {/if}
    <div class="flex flex-row">
        <div class="pt-6">
            <section class="nes-container with-title max-w-screen-sm my-4">
                <h1 class="text-2xl title">Inventory to claim</h1>

            <table>
                <thead>
                    <tr>
                        <th class="w-64">Item</th>
                        <th class="pr-6">Amount</th>
                        <th>Difficulty</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Normal Banana</td>
                        <td>{items.normal.length}</td>
                        <td>6</td>
                    </tr>
                    <tr>
                        <td>Thena Meme Good</td>
                        <td>{items.steel.length}</td>
                        <td>7</td>
                    </tr>
                    <tr>
                        <td>Golden Banana</td>
                        <td>{items.golden.length}</td>
                        <td>8</td>
                    </tr>
                    <tr>
                        <td>Crystal Banana</td>
                        <td>{items.crystal.length}</td>
                        <td>9</td>
                    </tr>
                    <tr>
                        <td>Mystic Banana</td>
                        <td>{items.mystic.length}</td>
                        <td>10</td>
                    </tr>

                </tbody>
            </table>
            </section>
        </div>
        <div class="mt-9 mx-auto pl-6">
            <p class="text-sm max-w-screen-sm">
                Banana is an idle miner Game, in which you use your browser to get valid nonce
                to mine Banana! In Banana you use you luck and mining power to gain even more Banana!
                All the items you can claim will be grouped and you can claim them all at once.
            </p>
        </div>
    </div>
    <div class="pt-6">

        <div class="flex flex-row">
            <section class="nes-container with-title w-96 my-4">
                <h1 class="text-2xl title">Cores</h1>
                <p>Using {coresSelected +( coresSelected>1 ? ' cores' : ' core')} to mine of {cores} cores.</p>
                <button type="button" class="nes-btn"
                on:click={coreAdd}
                class:is-disabled={coresSelected >= cores || globalStatus=='mining' }
                disabled={coresSelected >= cores || globalStatus=='mining'}>+</button>
                <button type="button" class="nes-btn"
                on:click={coreSub}
                class:is-disabled={coresSelected < 2 || globalStatus=='mining'}
                disabled={coresSelected < 2 || globalStatus=='mining'}>-</button>
            <br>
            <label for="default_select">Search for</label>
<div class="nes-select">
  <select id="default_select" bind:value={minDif}>
    <option value="0" disabled selected>Select...</option>
    <option value="6">Normal</option>
    <option value="7">Thena Meme Good</option>
    <option value="8">Golden</option>
    <option value="9">Crystal</option>
    <option value="10">Mystic</option>
  </select>
</div>

            <br>
            <p class="text-sm mt-3">Total Speed: {Math.floor(totalSpeed / 1000)} KH/s</p>
            </section>

            <section class="nes-container with-title w-96 ml-4 my-4">
                <h1 class="text-2xl title">status</h1>

                <p class="text-sm">Global status: {globalStatus}</p>
                {#each Array(coresSelected) as _,i}
                <div class="flex flex-row items-center py-1">
                    <span class="text-xs pr-1">CPU:{i+1}</span>
                    <progress class="nes-progress h-5" value={((workers[i] && workers[i].loops || 0) % 10)* 10} max="100"></progress>
                    </div>
                {/each}

            </section>
    </div>
        {#if !$account}<p>Once you are connected, you can start mining!</p>{/if}
        <button type="button" class="nes-btn is-primary" class:is-disabled={globalStatus != 'idle' || !$loadReady} disabled={globalStatus != 'idle'||!$loadReady} on:click={startMining}>Start Mining</button>
        <button type="button" class="nes-btn is-warning"
        class:is-disabled={globalStatus!='mining'||!$loadReady}
        disabled={globalStatus!='mining'||!$loadReady} on:click={doStop}>Stop</button>

            <button type="button" class="nes-btn is-success"
                class:is-disabled={totalItems == 0} on:click={claim} disabled={totalItems == 0}>Claim!</button>
    </div>
</div>