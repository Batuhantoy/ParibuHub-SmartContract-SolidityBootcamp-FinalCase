import { useState,useEffect } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

function App() {
  const [state, setState] = useState({
    provider:null,
    signer:null,
    contract:null
  })
  const[account,setAccount]=useState('Not Connected');
  useEffect(()=>{
    const template = async()=>{
      const contractAddress ="0x73644c1d1452b5fffce1ef41558ce84dfc11ab5d";
      const contractABI ="";
      try{
        const {ethereum}=window;

        const account = await ethereum.request({
        method:"eth_requestAccounts"
        })
        setAccount(account);
        const provider = new ethers.providers.Web3Provider(ethereum); // read the blockchain
        const signer = provider.getSigner(); // write the blockchain

        const contract = new ethers.Contract(
          contractAddress,
          contractABI,
          signer
        )
        setState({provider,signer,contract});
      }catch(error){
        alert(error);
      }

    }
    template();
  },[])

  return (
    <>
      <div>
        
      </div>
    </>
  )
}

export default App
