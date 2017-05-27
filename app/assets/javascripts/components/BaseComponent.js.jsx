class BaseEditField extends React.Component {
  constructor(props) {
    // props e.g. { name:"listing[listing_name]", id:"listing_listing_name", value:"1 Main St.", error:"is required",
    //              label:"LISTING NAME *", instruction:"This is the headline of your listing. (max. 40 charaters) ", 
    //              placeholder:"e.g. Blk 404 Bedok Ave 3 or Meadow Towers"}
    //              maxLength="25" size="25"
    //            }
    super(props);

    if( "select_options" in props ) {
      const opts = props.select_options.map((option) =>
          <option key={option.id} value={option.id}>
            {option.description}
          </option>
      );
      
      opts.unshift( <option key="selOpt" value="">Select an option</option>);

      this.state = { value: props.value, select_options: opts};
    }
    else{
      this.state = { value: props.value };
    }

    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(e){
    this.setState({ value: e.target.value });
  }
  
  componentWillReceiveProps(nextProps) {
    this.setState({value: nextProps.value});
  }
  
  render() {
    // return <div> ... desc to implement ... </div>
  }
}

class CustomEdit extends BaseEditField {
  // CustomInputText
  // CustomTextArea
  // CustomSelect
  constructor(props) {
    // props e.g. { name:"listing[listing_name]", id:"listing_listing_name", value:"1 Main St.", error:"is required",
    //              label:"LISTING NAME *", instruction:"This is the headline of your listing. (max. 40 charaters) ", 
    //              placeholder:"e.g. Blk 404 Bedok Ave 3 or Meadow Towers"}
    //              maxLength="25" size="25"
    //            }
    super(props);
  }
  
  shouldComponentUpdate(nextProps, nextState) {
// alert(this.props.error);
// alert(nextProps.error);
// alert(this.state.value);
// alert(nextState.value);
    // if ( this.state.value.length != nextState.value.length ) { return true;}
    // if ( this.props.error.length != nextProps.error.length ) { return true;}
    // if ( this.props.error != nextProps.error ) { return true;}
    // if ( this.state.value != nextState.value ) { return true;}
    
    //if ( this.state.value.length != nextState.value.length ) {
    if ( ( typeof this.state.value == 'number' ? this.state.value.toString().length : this.state.value.length) != ( typeof nextState.value == 'number' ? nextState.value.toString().length : nextState.value.length) ) {
//      alert('111 ' + this.props.id + ' this.state.value.length ' + this.state.value.length + ' nextState.value.length ' + nextState.value.length + ' nextState.value ' + nextState.value + ' typeof nextState.value ' + typeof nextState.value);
      return true;
    }
    if ( this.props.error.length != nextProps.error.length ) {
//      alert('222 ' + this.props.id + ' this.props.error.length ' + this.props.error.length + ' nextProps.error.length ' + nextProps.error.length);
      return true;
    }
    if ( this.props.error != nextProps.error ) {
//      alert('333 ' + this.props.id);
      return true;
    }
    if ( ( typeof this.state.value == 'number' ? this.state.value.toString() : this.state.value) != ( typeof nextState.value == 'number' ? nextState.value.toString() : nextState.value) ) {
//      alert('444  ' + this.props.id);
      return true;
    }
    return false;
  }
}

class PlainEdit extends BaseEditField {
  constructor(props) {
    super(props);
  }
  
  shouldComponentUpdate(nextProps, nextState) {
    if ( ( typeof this.state.value == 'number' ? this.state.value.toString().length : this.state.value.length) != ( typeof nextState.value == 'number' ? nextState.value.toString().length : nextState.value.length) ) { return true;}
    if ( ( typeof this.state.value == 'number' ? this.state.value.toString() : this.state.value) != ( typeof nextState.value == 'number' ? nextState.value.toString() : nextState.value) ) { return true;}
    return false;
  }
}

class PlainInputText extends PlainEdit {
  render() {
   var input_text = null;

   if ( "placeholder" in this.props) {
     if ( "readOnly" in this.props) {
       input_text = <input className="field form-control" placeholder={this.props.placeholder} maxLength={this.props.maxLength} size={this.props.size} type="text" value={this.state.value} onChange={this.handleChange} name={this.props.name} id={this.props.id} readOnly="readonly" />
     }
     else {
       input_text = <input className="field form-control" placeholder={this.props.placeholder} maxLength={this.props.maxLength} size={this.props.size} type="text" value={this.state.value} onChange={this.handleChange} name={this.props.name} id={this.props.id} />
     }
   }
   else {
     if ( "readOnly" in this.props) {
       input_text = <input className="field form-control" maxLength={this.props.maxLength} size={this.props.size} type="text" value={this.state.value} onChange={this.handleChange} name={this.props.name} id={this.props.id} readOnly="readonly" />
     }
     else {
       input_text = <input className="field form-control" maxLength={this.props.maxLength} size={this.props.size} type="text" value={this.state.value} onChange={this.handleChange} name={this.props.name} id={this.props.id} />
     }
   }

   return input_text;
  }
}

class PlainRadioYesNo extends PlainEdit {
  render() {
// alert(this.state.value); // 1 => Yes, 0 => No
    return <div>
             <label htmlFor={this.props.id + "_1"}>{this.props.label} &nbsp; &nbsp;</label>
             <input className="field" type="radio" value="1" onChange={this.handleChange} name={this.props.name} id={this.props.id + "_1"} checked={this.state.value == "1"} /> <label htmlFor={this.props.id + "_1"}>Yes &nbsp;</label>
             <input className="field" type="radio" value="0" onChange={this.handleChange} name={this.props.name} id={this.props.id + "_0"} checked={this.state.value == "0"} /> <label htmlFor={this.props.id + "_0"}>No &nbsp;</label>
           </div>
  }
}

class PlainCheckbox extends PlainEdit {
  constructor(props) {
    super(props);
    if (props.checked == '') {
// alert( 'PlainCheckbox constructor chked false');
      this.state = { checked: false};
    }
    else{
// alert( 'PlainCheckbox constructor chked true');
      this.state = { checked: true};
    }
  }
  
  handleChange(e){
    this.setState({ checked: !this.state.checked });
// alert( 'PlainCheckbox handleChange');
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.checked == '') {
      this.setState({checked: false});
    }
    else{
      this.setState({checked: true});
    }
  }
  
  shouldComponentUpdate(nextProps, nextState) {
// alert( 'PlainCheckbox shouldComponentUpdate');
    if ( this.state.checked != nextState.checked ) { return true;}
    return false;
  }

  render() {
//alert( 'PlainCheckbox render checked' + ( this.state.checked ? 'true' : 'false') + ' this.props.description ' + this.props.description);
// alert( 'PlainCheckbox render checked' + ( this.state.checked ? 'true' : 'false') + ' this.props.description ' + this.props.description);
    return <div className="checkbox custom-checkbox col-sm-4">
             <label htmlFor={this.props.id + '_' + this.props.value}>
             { this.state.checked
                 ? <input type="checkbox" onChange={this.handleChange} value={this.props.value} checked name={this.props.name} id={this.props.id + '_' + this.props.value} />
                 : <input type="checkbox" onChange={this.handleChange} value={this.props.value} name={this.props.name} id={this.props.id + '_' + this.props.value} />
             }
            <span className="fa fa-check"></span>{this.props.description}
            </label>
           </div>
  }
}

class CustomInputText extends CustomEdit {
  render() {
    var input_text = null;

    if ( "placeholder" in this.props) {
      if ( "readOnly" in this.props) {
        input_text = <input className="field form-control" placeholder={this.props.placeholder} maxLength={this.props.maxLength} size={this.props.size} type="text" value={this.state.value} onChange={this.handleChange} name={this.props.name} id={this.props.id} readOnly="readonly" />
      }
      else {
        input_text = <input className="field form-control" placeholder={this.props.placeholder} maxLength={this.props.maxLength} size={this.props.size} type="text" value={this.state.value} onChange={this.handleChange} name={this.props.name} id={this.props.id} />
      }
    }
    else {
      if ( "readOnly" in this.props) {
        input_text = <input className="field form-control" maxLength={this.props.maxLength} size={this.props.size} type="text" value={this.state.value} onChange={this.handleChange} name={this.props.name} id={this.props.id} readOnly="readonly" />
      }
      else {
        input_text = <input className="field form-control" maxLength={this.props.maxLength} size={this.props.size} type="text" value={this.state.value} onChange={this.handleChange} name={this.props.name} id={this.props.id} />
      }
    }
// alert('CustomInputText render ' + this.props.id);
    return <div className="row">
             <div className="col-sm-4">
               <label htmlFor={this.props.id}> {this.props.label} </label>
               <span className={this.props.error=='' ? 'hide' : 'field_errors'} >{this.props.error}</span>
             </div>
             <div className="col-sm-8">
               <span>{this.props.instruction}{this.props.error=='' ? '' : '\u00a0'}</span>
               {input_text}
             </div>
             <p>&nbsp;</p>
           </div>
  }
}

CustomInputText.defaultProps = {
  instruction: ''
};

class CustomTextArea extends CustomEdit {
  render() {
// alert('CustomTextArea render ' + this.props.id);
    return <div className="row">
             <div className="col-sm-4">
               <label htmlFor={this.props.id}> {this.props.label} </label>
               <span className={this.props.error=='' ? 'hide' : 'field_errors'} >{this.props.error}</span>
             </div>
             <div className="col-sm-8">
               <span>{this.props.error=='' ? '' : '\u00a0'}</span><textarea className="field form-control" maxLength={this.props.maxLength} size={this.props.size} value={this.state.value} onChange={this.handleChange} name={this.props.name} id={this.props.id} />
             </div>
             <p>&nbsp;</p>
           </div>
  }
}

CustomTextArea.defaultProps = {
  rows: '16'
};


class CustomSelect extends CustomEdit {
  render() {
// alert('CustomSelect render ' + this.props.id);
    return <div className={ "hide" in this.props ? "row hide" : "row" }>
             <div className="col-sm-4">
               <label htmlFor={this.props.id}> {this.props.label} </label>
               <span className={this.props.error=='' ? 'hide' : 'field_errors'} >{this.props.error}</span>
             </div>
             <div className="col-sm-8">
               <span>{this.props.error=='' ? '' : '\u00a0'}</span>
               <select value={this.state.value} className="field form-control" name={this.props.name} id={this.props.id} onChange={ "handleChange" in this.props ? this.props.handleChange : this.handleChange}>
                 {this.state.select_options}
               </select>
             </div>
             <p>&nbsp;</p>
           </div>
  }
}
