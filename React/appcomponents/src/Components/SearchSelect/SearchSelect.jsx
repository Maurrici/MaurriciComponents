import style from "./SearchSelect.module.css";

import React, { useEffect, useState, useRef, useCallback } from "react";
import { Form } from "react-bootstrap";
import { BsChevronDown, BsPlus } from "react-icons/bs";

/*
  name: name of input form
  valueDefault: initial value of select
  getName: function to get value that is not in the children
  handleChange: function called after the value change
  handleSearch: function that sends a string, it is expected that after the call the children will change
  btnName: the text that will be displayed on the button
  btnClick: the action that will be called after click
*/

const SearchSelect = ({name, value:valueDefault, getName, handleChange, handleSearch, btnName, btnClick, placeholder="Selecione uma opção", children}) => {
    const [value, setValue] = useState(valueDefault != undefined ? valueDefault : "");
    const [valueName, setValueName] = useState("");
    const [valuesNames, setValuesNames] = useState([]);
    const [selectMode, setSelectMode] = useState(false);
    const inputRef = useRef(null);
    const selectRef = useRef(null);
    
    useEffect(() => { // Maps the options
        setValuesNames(React.Children.map(children, child => {
            return {
                value: child.props.value,
                name: child.props.children.toString().replaceAll(',', '') 
            }
        }))
    }, [children]);

    const updateValueName = useCallback(() => { // Change the name displayed in select
        let item = valuesNames.find(valueName => valueName.value == value);
        
        if(item) setValueName(item.name); // if the value is on the children 
        else if(value != '' && value != undefined){ // if not then use the getName
            getName(value).then(name => {
                setValueName(name);
            })
        }
    }, [value, valuesNames])

    useEffect(() => { // Update the name displayed in select according to value
        // if not exist default value then the first option will be selected
        if(!selectMode){
            updateValueName();
        }
    }, [value, updateValueName, valuesNames]); 

    useEffect(() => { // Call handleSearch with name search by user
        if(typeof valueName == "string"){
            if(valueName != "") setSelectMode(true);
            handleSearch(valueName);
        }
    }, [valueName])
    
    return(
        <div className={style["select-box"]}>
            {/* Input info*/}
            <input type="hidden" name={name} value={value} ref={inputRef} onClick={(e) => handleChange(e)} /> 

            {/* Input view */}
            <Form.Control
                placeholder={placeholder}
                className={style["select-box-input"]}
                type="text" 
                onClick={(e) => setValueName("")}
                onChange={(e) => setValueName(e.target.value)}
                value={valueName}
                ref={selectRef}
                onFocus={e => e.target.parentElement.classList.add(style["focus"])}
                onBlur={e => {
                    e.target.parentElement.classList.remove(style["focus"])
                    inputRef.current.click();
                    setSelectMode(false);
                    updateValueName();
                }} />
            
            <BsChevronDown className={style["icon-select"]}/>

            {/* Options */}
            <div className={style["dropDown"]}>
                {/* Add props for the children */}
                <option className={style["item"]} onMouseDown={() => {setValue(undefined)}}>{placeholder}</option>
                { 
                    React.Children.map(children, child => {
                        return React.cloneElement(child, {
                            className: style["item"],
                            onMouseDown: () => {
                                setValue(child.props.value);
                            }
                        });
                    })
                }
                {
                    btnName != undefined &&
                    <div className={`${style["item"]} ${style["item-new"]}`} onMouseDown={() => {
                        selectRef.current.blur();
                        if(btnClick != undefined) btnClick()
                    }}>
                        <BsPlus />
                        {btnName}
                    </div>
                }
            </div>
        </div>
    )
}

export default SearchSelect;