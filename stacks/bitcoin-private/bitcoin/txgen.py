import subprocess
import random
import time
import json
import shlex

with open("/home/ubuntu/address.txt", "r") as f:
	address = f.read()

unspent_list = json.loads(subprocess.check_output(f"/home/ubuntu/bitcoin-cli -regtest listunspent", shell=True).decode('utf8').strip())
unspent_list = [o for o in unspent_list if (o['amount'] >= 0.001 and o['address'] == address)][0:100]

# Gen
while True:
	unspent = unspent_list.pop(0)
	# print(unspent)
	amount = unspent['amount']
	hash = subprocess.check_output(f"/home/ubuntu/bitcoin-cli -regtest createrawtransaction '[{{\"txid\": \"{unspent['txid']}\",\"vout\": {unspent['vout']}}}]' '[{{\"{address}\": {amount}}}]'", shell=True).decode('utf8').strip()
	# print(hash)
	outjson = shlex.quote(json.dumps([unspent]))
	hash = json.loads(subprocess.check_output(f"/home/ubuntu/bitcoin-cli -regtest signrawtransactionwithwallet '{hash}' {outjson}", shell=True).decode('utf8').strip())['hex']
	# print(hash)
	subprocess.check_output(f"/home/ubuntu/bitcoin-cli -regtest sendrawtransaction '{hash}'", shell=True)
	unspent = json.loads(subprocess.check_output(f"/home/ubuntu/bitcoin-cli -regtest decoderawtransaction '{hash}'", shell=True).decode('utf8').strip())
	# print(unspent)
	unspent = {
		'txid': unspent['txid'],
		'vout': unspent['vout'][0]['n'],
		'scriptPubKey': unspent['vout'][0]['scriptPubKey']['hex'],
		'amount': unspent['vout'][0]['value'],
	}
	# print(unspent)
	unspent_list.append(unspent)
	time.sleep(0.01)
