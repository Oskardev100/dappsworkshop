import { useState } from "react";
import useEth from "../../contexts/EthContext/useEth";

function ContractBtns({ setValue }) {
  const { state: { contract, accounts } } = useEth();
  const [inputValue, setInputValue] = useState("");
  const [title, setTitle] = useState('');
   const [description, setDescription] = useState('');

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
    const foundResult = await contract.methods.Found().send({
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

  const sendPayment = async() => {
    const sendPayment = await contract.methods.PayVendor().send( {
      from: accounts[0],
      //value: 100000000,
    }).
    then((tx) => {
      console.log('Payment transaction hash:', tx.transactionHash);
    })
    .catch((error) => {
      console.error('Error while sending payment:', error);
    });
  }

  const addCampaing = async() => {

    const title = "title a";
    const description = "desc a";
    try {
      const addNewCampaign = await contract.methods.addCampaign(title, description).send({
        from: accounts[0]
    });
      
    } catch (error) {
      console.log(error);
    }

    
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
      <div>
        <button onClick={sendPayment}>Send Payment</button>
      </div>
      
      <div>

      <label>
        Title:
        <input type="text" onChange={(e) => setTitle(e.target.value)}  /> 
        </label>
      <label>
        Description:
        <input type="text"  value={description}  onChange={(e) => setDescription(e.target.value)}/>
      </label>
      <br />
      
        





        <button onClick={addCampaing}>Add Campaign</button>
      </div>

    </div>
  );
}

export default ContractBtns;
