import './App.css';
import SearchSelect from "./Components/SearchSelect/SearchSelect";
import { useState } from 'react';


function App() {
  const [ID, setID] = useState(undefined);
  const [options, setOptions] = useState([{id: 1, name: "Teste1"}, {id: 2, name: "Teste2"}]);

  const handleSearch = (search) => {}

  const getName = (value) => {
    return "Teste"
  }

  return (
    <div className="App w-25">
      <SearchSelect
        name="id"
        value={ID}
        handleChange={(e) => setID(e.target.value)}
        handleSearch={handleSearch}
        getName={getName}
        btnName="Criar novo"
        btnClick={() => alert("Botão interno do select")}
      >
        {
          options &&
          options.map(option => (
            <option key={option.id} value={option.id}>{option.name}</option>
          ))
        }
      </SearchSelect>
    </div>
  );
}

export default App;
