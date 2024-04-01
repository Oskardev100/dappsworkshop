import { useState } from "react";
import useEth from "../../contexts/EthContext/useEth";

function ContractBtns({ setValue }) {
  const { state: { contract, accounts } } = useEth();
  const [inputValue, setInputValue] = useState("");

  const handleInputChange = e => {
    if (/^\d+$|^$/.test(e.target.value)) {
      setInputValue(e.target.value);
    }
  };

  const read = async () => {
    const value = await contract.methods.read().call({ from: accounts[0] });
    setValue(value);
  };

  const write = async e => {
    if (e.target.tagName === "INPUT") {
      return;
    }
    if (inputValue === "") {
      alert("Please enter a value to write.");
      return;
    }
    const newValue = parseInt(inputValue);
    await contract.methods.write(newValue).send({ from: accounts[0] });
  };

  const getBalance = async () => {
    const balance = await  contract.methods.balance().call( { from: accounts[0]});
    console.log('contract balance is:' + balance);

  }

  const addFounds = async() => {
    //const collectAmount = web3.utils.toWei('10', 'finney'); // Convert 0.1 ETH to Wei

    const foundResult = await contract.methods.Collect().send({
      from: accounts[0],
      value: 100000000,
    })
    .then((tx) => {
      console.log('Collect transaction hash:', tx.transactionHash);
    })
    .catch((error) => {
      console.error('Error collecting funds:', error);
    });
    console.log(foundResult);
  }

  return (
    <div className="btns">

      <button onClick={read}>
        read()
      </button>

      <div onClick={write} className="input-btn">
        write(<input
          type="text"
          placeholder="uint"
          value={inputValue}
          onChange={handleInputChange}
        />)
      </div>

      <div>
        <button onClick={getBalance}>Get Balance</button>
      </div>
      <div>
        <button onClick={addFounds}>Add Founds</button>
      </div>

    </div>
  );
}

export default ContractBtns;
