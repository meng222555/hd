class MapUpdateableSelect extends CustomSelect {
  componentDidUpdate( prevProps, prevState) {
//  alert( 'EstateSelect prevState value ' + prevState.value);
//  alert( 'EstateSelect this.state value ' + this.state.value);
//  alert( 'EstateSelect ... componentDidUpdate ... prevState value ' + prevState.value + ' this.state value ' + this.state.value);
    if (prevState.value!=this.state.value) {
      this.props.notifyParent();
    }
  }
}

class PostalCodeInputText extends CustomInputText {
  componentDidUpdate( prevProps, prevState) {
//  alert( 'PostalCodeInputText prevState value ' + prevState.value);
//  alert( 'PostalCodeInputText this.state value ' + this.state.value);
    if (prevState.value!=this.state.value) {
      this.props.notifyParent();
    }
  }
}

class SizeAreaInputText extends CustomInputText {
  componentDidMount(){
    // reflect label text accordingly to property_type
    //   property_type "1" HDB => sqm
    //   else => sqft
    var $label = $("label[for='"+this.props.id+"']");

    var property_type = $('#listing_property_type_id').val(); // mounted earlier than size_area

    if (property_type=='') {
      $label.text("SIZE OF UNIT")
    }
    else if (property_type=='1') {
      $label.text("SIZE OF UNIT(SQM) *")
    }
    else {
      $label.text("SIZE OF UNIT(SQFT) *")
    }

  }
}

class PropertyTypeCtrlsForListingFormComponent extends React.Component {
  constructor(props) {
//   props => { property_type_id: { value: "2", error: "is required"}, property_sub_type_id: { value: "3", error: "is required"},
//                options_for_property_type: [{id: 1, description: "HDB"},{id: 2, description: "Landed Property"}],
//                options_for_property_sub_type: [ {id: 1, description: "4 Room", property_type_id: "1"},{id: 2, description: "5 Room", property_type_id: "1"},
//                                                 {id: 3, description: "Terrace", property_type_id: "2"},{id: 4, description: "GCB", property_type_id: "2"}
//                                               ]
//            }
    super(props);

    this.state = { property_type_id_value: props.property_type_id.value };
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(e){
    var $label = $("label[for='listing_size_area']");

    var property_type = e.target.value;

    if (property_type=='') {
      $label.text("SIZE OF UNIT");
      $("#listing_size_unit").val('');
    }
    else if (property_type=='1') {
      $label.text("SIZE OF UNIT(SQM) *");
      $("#listing_size_unit").val('SQM');
    }
    else {
      $label.text("SIZE OF UNIT(SQFT) *");
      $("#listing_size_unit").val('SQFT');
    }

    this.setState({ property_type_id_value: e.target.value });
//  alert(this.props.property_sub_type_id.value);
//  this.props.property_sub_type_id.value = '77';
//  this.props.property_sub_type_id.value = '_filter_';
  }

  render() {
// alert(this.props.property_sub_type_id.value);
    var estate_or_district = null;

    if ( this.state.property_type_id_value == '') {
      estate_or_district = 
        <div>
          <input type="text" value="" className="hide" readOnly="readonly" name="listing[district_or_estate]" id="listing_district_or_estate" />
          <CustomInputText name="listing[estate_id]" id="listing_estate_id"
            value=""
            error=""
            label="ESTATE"
            maxLength="10" size="10"
            readOnly="readonly"
          />
          <input type="text" value="" className="hide" readOnly="readonly" name="listing[district_id]" id="listing_district_id" />
        </div>
    }
    else if ( this.state.property_type_id_value == '1') {
      estate_or_district = 
        <div>
          <input type="text" value="e" className="hide" readOnly="readonly" name="listing[district_or_estate]" id="listing_district_or_estate" />
          <MapUpdateableSelect name="listing[estate_id]" id="listing_estate_id"
            value={this.props.estate_id.value} error={this.props.estate_id.error}
            label="ESTATE"
            select_options = {this.props.options_for_estate}
            notifyParent={this.props.notifyParent}
            key="x"
          />
          <input type="text" value="" className="hide" readOnly="readonly" name="listing[district_id]" id="listing_district_id" />
        </div>
    }
    else { // assume '1' or '2'
      estate_or_district = 
        <div>
          <input type="text" value="d" className="hide" readOnly="readonly" name="listing[district_or_estate]" id="listing_district_or_estate" />
          <MapUpdateableSelect name="listing[district_id]" id="listing_district_id"
            value={this.props.district_id.value} error={this.props.district_id.error}
            label="DISTRICT"
            select_options = {this.props.options_for_district}
            notifyParent={this.props.notifyParent}
            key="y"
          />
          <input type="text" value="" className="hide" readOnly="readonly" name="listing[estate_id]" id="listing_estate_id" />
        </div>
    }

    return <div id="property_type_ctrls">
             <PropertyTypeDropdown name="listing[property_type_id]" id="listing_property_type_id"
               value={this.state.property_type_id_value}
               error={this.props.property_type_id.error}
               label="PROPERTY TYPE *"
               select_options={this.props.options_for_property_type}
               handleChange={this.handleChange}
             />
             <FilterableChildOfPropertyTypeDropdown name="listing[property_sub_type_id]" id="listing_property_sub_type_id"
               property_type_id_value={this.state.property_type_id_value}
               value={this.props.property_sub_type_id.value}
               error={this.props.property_sub_type_id.error}
               label="PROPERTY SUB-TYPE"
               select_options={this.props.options_for_property_sub_type}
             />
             { this.props.listing_type == 'FOR SALE' 
                ? <FilterableChildOfPropertyTypeDropdown name="listing[tenure_id]" id="listing_tenure_id"
                    property_type_id_value={this.state.property_type_id_value}
                    value={this.props.tenure_id.value}
                    error={this.props.tenure_id.error}
                    label="TENURE"
                    select_options={this.props.options_for_tenure}
                  />
                : <input className="hidden" readOnly="readonly" type="text" value="" name="listing[tenure_id]" id="listing_tenure_id" />
             }
             <div id="estate_or_district">
             { estate_or_district }
             </div>
           </div>
  }

}

class PropertyTypeDropdown extends CustomSelect {
}

class FilterableChildOfPropertyTypeDropdown  extends React.Component {
  constructor(props) {
// props => { property_type_id_value: "1", value: "2",
//            error: "is required",
//            select_options: PTR_TO [ {id: 1, description: "4 Room", property_type_id: "1"},{id: 2, description: "5 Room", property_type_id: "1"},
//                                                    {id: 3, description: "Terrace", property_type_id: "2"},{id: 4, description: "GCB", property_type_id: "2"}
//                                                  ]
//          }
    super(props);

    var filter = props.property_type_id_value;
    
    const opts = props.select_options.filter(function(option) {
      return option.property_type_id == filter;
      }).map((option) =>
        <option key={option.id} value={option.id}>
          {option.description}
        </option>
    );
    
    opts.unshift( <option key="selOpt" value="">Select an option</option>);

    this.state = { property_type_id_value: props.property_type_id_value,
                   value: props.value,
                   select_options: opts
                 };

    this.handleChange = this.handleChange.bind(this);
  }
  
  handleChange(e){
    this.setState({ value: e.target.value });
  }
  
  componentWillReceiveProps( nextProps){

    if (this.props.property_type_id_value != nextProps.property_type_id_value){
      var filter = nextProps.property_type_id_value;

      const opts = nextProps.select_options.filter(function(option) {
        return option.property_type_id == filter;
        }).map((option) =>
          <option key={option.id} value={option.id}>
            {option.description}
          </option>
      );

      opts.unshift( <option key="selOpt" value="">Select an option</option>);

      var property_sub_type_id_matching_filter = '';

      for (var i = 0, len = nextProps.select_options.length; i < len; i++) {
        if ( nextProps.select_options[i].property_type_id == filter) {
          property_sub_type_id_matching_filter = nextProps.select_options[i].id;
          break;
        }
      }

      this.setState({ property_type_id_value: nextProps.property_type_id_value,
                value: property_sub_type_id_matching_filter,
                select_options: opts
              });
    }
  }
  
  shouldComponentUpdate(nextProps, nextState) {
    if ( this.state.property_type_id_value != nextState.property_type_id_value ) { return true;}
    if ( this.state.value != nextState.value ) { return true;}
    if ( this.props.error.length != nextProps.error.length ) { return true;}
    if ( this.props.error != nextProps.error ) { return true;}
    return false;
  }

  render() {
// alert('FilterableChildOfPropertyTypeDropdown ' + this.props.id + ' render ');
    return <div className="row">
             <div className="col-sm-4">
               <label htmlFor={this.props.id}> {this.props.label} * </label>
               <span className={this.props.error=='' ? 'hide' : 'field_errors'} >{this.props.error}</span>
             </div>
             <div className="col-sm-8">
               {this.props.error=='' ? '' : '\u00a0'}
               <select value={this.state.value} className="field form-control" name={this.props.name} id={this.props.id} onChange={this.handleChange}>
                 {this.state.select_options}
               </select>
             </div>
             <p>&nbsp;</p>
           </div>
  }

}

class ListingFormComponent extends React.Component {
  constructor(props) {
    super(props);

    this.state = props; // only key:url of props remain as prop
                        // remaining keys are stateful ... and refreshed from server when usr submits form
                        //   record, errors_summary, retrieved_listing_name_is_blank
                        // Server refresh does excludes url
// alert( JSON.stringify( this.state));
    this.handleSubmit = this.handleSubmit.bind(this);
    this.updateMap = this.updateMap.bind(this);
    this.handleEstateChange = this.handleEstateChange.bind(this);
    this.handlePostalCodeChange = this.handlePostalCodeChange.bind(this);    

    this.placesSearchText = this.placesSearchText.bind(this);
  }

  placesSearchText(){

    var $district_or_estate = $('#listing_district_or_estate').val();

    if ( $district_or_estate == 'e') {
      $district_or_estate = $('#listing_estate_id').find(":selected").text();

      if ( $('#listing_estate_id').val() == '') {
        $district_or_estate = '';
      }

    }
    else if ( $district_or_estate == 'd') {
      $district_or_estate = $('#listing_district_id').find(":selected").text();

      if ( $('#listing_district_id').val() == '') {
        $district_or_estate = '';
      }

    }
    else { // ""
      $district_or_estate = "";
    }

    var postcode = $('#listing_postal_code').attr('value');

    var search_text = 'Singapore ' + $district_or_estate + ' ' + postcode;
    return search_text;
  }

  updateMap(){
    App.Util.GoogleMaps.PlacesSearchBox.search( this.placesSearchText());
  }

  handleEstateChange(){
//  alert( 'handleEstateChange called        ' + $('#listing_estate_id').val() + ' TEXT ' + $('#listing_estate_id').find(":selected").text() );
    this.updateMap();
  }

  handlePostalCodeChange(){
    // alert( 'handlePostalCodeChange called        ' + $('#listing_postal_code').attr('value') );
    this.updateMap();
  }

  // http://checkbox12.blogspot.sg/2015/10/how-to-use-collectioncheckboxes.html
  render() {
    var  sceneries_of_listing = this.state.sceneries_of_listing.map((scenery) =>
              <PlainCheckbox name="listing[scenery_ids][]"
                             id="listing_scenery_ids"
                             value={scenery.id}
                             checked={scenery.checked}
                             description={scenery.description}
                             key={scenery.id}
              />
    );

    var  features_of_listing = this.state.features_of_listing.map((feature) =>
              <PlainCheckbox name="listing[feature_ids][]"
                             id="listing_feature_ids"
                             value={feature.id}
                             checked={feature.checked}
                             description={feature.description}
                             key={feature.id}
              />
    );

    var  amenities_of_listing = this.state.amenities_of_listing.map((amenity) =>
              <PlainCheckbox name="listing[amenity_ids][]"
                             id="listing_amenity_ids"
                             value={amenity.id}
                             checked={amenity.checked}
                             description={amenity.description}
                             key={amenity.id}
              />
    );

    const errors_summary_listItems = this.state.errors_summary.map((field) =>
        <li key={field.error.substr(0,16)}>
          <a href={field.fieldname} className="errors_summary">{field.error}</a>
        </li>
    );

    return <div className="container contents">
      <div id="errors_summary" className={this.state.errors_summary.length==0 ? 'hide' : ''}>
        <p>&nbsp; Error(s) prohibited this listing from being updated:</p>
        <ul>{errors_summary_listItems}</ul>
      </div>
      <div className="row">
        <div className="col-12">
          <h1>List My Property</h1>
          <h4>Fields with asterisk * are required for Publishing listing</h4>
            <div className="container">
              <div className="row">
                <div className="col-sm-12">
                  <form ref={(domForm) => { this.domForm = domForm; }} onSubmit={this.handleSubmit}>
                    <div id="sticky-anchor"></div>
                    <div id="stickable">
                      <div id="update_listing_button">
                        <br />
                        <button type="submit" className="btn btn-red white" >Update</button>
                        &nbsp;&nbsp;<a className="btn btn-red white" href={this.props.url} id="btn_preview">Preview</a>
                        &nbsp;&nbsp;<a className={this.state.retrieved_listing_name_is_blank == "false" ? "btn btn-red white" : "btn btn-red white hide"} href="#" id="media">Photos</a>
                      </div>
                    </div>
                    <br />                    

                    <CustomInputText name="listing[listing_name]" id="listing_listing_name"
                      value={this.state.record.listing_name.val} error={this.state.record.listing_name.error}
                      label="LISTING NAME *" instruction="This is the headline of your listing. (max. 40 charaters) "
                      placeholder="e.g. Blk 2 Bedok Ave 3 or Windy Towers"
                      maxLength="40" size="40"
                    />

                    <div className="row">
                      <div className="col-sm-4">
                        <label> LISTING TYPE </label>
                      </div>
                      <div className="col-sm-8">
                        <input className="field form-control" readOnly="readonly" type="text" value={this.state.record.listing_type.val} name="listing[listing_type]" id="listing_listing_type" />
                      </div>
                      <p>&nbsp;</p>
                    </div>

                    <CustomSelect name="listing[rental_type]" id="listing_rental_type"
                      value={this.state.record.rental_type.val} error={this.state.record.rental_type.error}
                      label="RENTAL TYPE"
                      select_options = {this.props.options_for_rental_type}
                      hide
                    />

                    <PropertyTypeCtrlsForListingFormComponent 
                      property_type_id={{value: this.state.record.property_type_id.val, error: this.state.record.property_type_id.error}}
                      property_sub_type_id={{ value: this.state.record.property_sub_type_id.val, error: this.state.record.property_sub_type_id.error}}
                      tenure_id={{ value: this.state.record.tenure_id.val, error: this.state.record.tenure_id.error}}
                      estate_id={{ value: this.state.record.estate_id.val, error: this.state.record.estate_id.error}}
                      district_id={{ value: this.state.record.district_id.val, error: this.state.record.district_id.error}}
                      options_for_property_type={this.props.options_for_property_type}
                      options_for_property_sub_type={this.props.options_for_property_sub_type}
                      options_for_tenure={this.props.options_for_tenure}
                      options_for_estate={this.props.options_for_estate}
                      options_for_district={this.props.options_for_district}
                      listing_type={this.props.listing_type}
                      notifyParent={this.handleEstateChange}
                    />

                    <CustomInputText name="listing[address]" id="listing_address"
                      value={this.state.record.address.val} error={this.state.record.address.error}
                      label="ADDRESS *"
                      maxLength="255" size="255"
                    />




                    <PostalCodeInputText name="listing[postal_code]" id="listing_postal_code"
                      value={this.state.record.postal_code.val} error={this.state.record.postal_code.error}
                      label="POSTAL CODE *"
                      maxLength="15" size="15"
                      notifyParent={this.handlePostalCodeChange}
                    />






                              
                    <div className="row">
                      <div className="col-sm-4">
                        <label htmlFor="listing_floor"> UNIT </label>
                      </div>
                      <div className="col-sm-8">
                        <div className="row">
                          <div className="col-sm-4">
                            <span>Floor</span>
                            <PlainInputText name="listing[floor]" id="listing_floor"
                              value={this.state.record.floor.val}
                              placeholder="e.g. #02"
                              maxLength="15" size="15"
                            />
                          </div>
                          <div className="col-sm-4">
                            <span>Number</span>
                            <PlainInputText name="listing[unit_no]" id="listing_unit_no"
                              value={this.state.record.unit_no.val}
                              maxLength="15" size="15"
                            />
                          </div>
                        </div>
                        <div className="row">
                        &nbsp;
                        </div>
                        <div className="row">
                          <div className="col-sm-8">
                            <PlainRadioYesNo name="listing[show_unit]" id="listing_show_unit"
                              value={this.state.record.show_unit.val}
                              label="Show the unit number in the Listing"
                            />
                          </div>
                        </div>
                      </div>
                      <p>&nbsp;</p>
                    </div>

           <div className="row">
             <div className="col-sm-4">
               <label> MAP </label>
             </div>
             <div className="col-sm-8">
               <div id="map" style={{height: "400px", width: "100%"}}>
               </div>
             </div>
             <p>&nbsp;</p>
           </div>

                    <input type="text" value={this.state.record.size_unit.val} className="hide" name="listing[size_unit]" id="listing_size_unit" />

                    <SizeAreaInputText name="listing[size_area]" id="listing_size_area"
                      value={this.state.record.size_area.val} error={this.state.record.size_area.error}
                      label="SIZE OF UNIT"
                      maxLength="6" size="6"
                    />

                    <CustomSelect name="listing[bedrooms]" id="listing_bedrooms"
                      value={this.state.record.bedrooms.val} error={this.state.record.bedrooms.error}
                      label="NUMBER OF BEDROOMS *"
                      select_options = {this.props.options_for_bedroom}
                    />

                    <CustomSelect name="listing[bathrooms]" id="listing_bathrooms"
                      value={this.state.record.bathrooms.val} error={this.state.record.bathrooms.error}
                      label="NUMBER OF BATHROOMS *"
                      select_options = {this.props.options_for_bathroom}
                    />

                    <CustomSelect name="listing[furnishing]" id="listing_furnishing"
                      value={this.state.record.furnishing.val} error={this.state.record.furnishing.error}
                      label="IS YOUR PROPERTY FURNISHED? *"
                      select_options = {this.props.options_for_furnishing}
                    />

                    <CustomSelect name="listing[floor_type]" id="listing_floor_type"
                      value={this.state.record.floor_type.val} error={this.state.record.floor_type.error}
                      label="FLOOR TYPE *"
                      select_options = {this.props.options_for_floor_type}
                    />

<br />
           <div className="row">
             <div className="col-sm-4">
               <label> SCENERY </label>
             </div>
             <div className="col-sm-8">
               <div className="row">
                 {sceneries_of_listing}
                 <input name="listing[scenery_ids][]" value="" type="hidden" readOnly="readonly" />
               </div>
             </div>
             <p>&nbsp;</p>
           </div>
<br />
           <div className="row">
             <div className="col-sm-4">
               <label> FEATURES </label>
             </div>
             <div className="col-sm-8">
               <div className="row">
                 {features_of_listing}
                 <input name="listing[feature_ids][]" value="" type="hidden" readOnly="readonly" />
               </div>
             </div>
             <p>&nbsp;</p>
           </div>
<br />
           <div className="row">
             <div className="col-sm-4">
               <label> AMENITIES </label>
             </div>
             <div className="col-sm-8">
               <div className="row">
                 {amenities_of_listing}
                 <input name="listing[amenity_ids][]" value="" type="hidden" readOnly="readonly" />
               </div>
             </div>
             <p>&nbsp;</p>
           </div>

                    <CustomTextArea name="listing[description]" id="listing_description"
                      value={this.state.record.description.val} error={this.state.record.description.error}
                      label="DESCRIPTION"
                      maxLength="2000" size="2000"
                    />

                    <CustomInputText name="listing[asking_price]" id="listing_asking_price"
                      value={this.state.record.asking_price.val} error={this.state.record.asking_price.error}
                      label="WHAT IS YOUR ASKING PRICE? *"
                      maxLength="255" size="255"
                    />

                  </form>
              </div>
            </div>
          </div>

          <br />
          <div className="row dashboard_nav">
          </div>
        </div>
      </div>
    </div>
  }

  handleSubmit(e) {
    e.preventDefault();

    var setstate = this.setState.bind(this);

    var fd = new FormData( this.domForm);

    var returnedJson = null;

    $("#listing_form_component").addClass("disabled");
    $('#spinner').removeClass('hide');

    var latitude = App.Util.GoogleMaps.PlacesSearchBox.getPlaceLat();
    var longitude = App.Util.GoogleMaps.PlacesSearchBox.getPlaceLng();

    fd.append('listing[lat]', latitude ? latitude : $('#location_lat').val());
    fd.append('listing[lng]', longitude ? longitude : $('#location_lng').val());
    
    $.ajax({
      url: this.props.url + '.json',
      dataType : "json",
      contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
      data: fd,
      processData: false,
      contentType: false,
      method: 'PUT'
    }).done(function(data)
    {
      // alert( 'OK');
      // alert( JSON.stringify(data));
      // setstate( {"record":{"id":{"val":150,"error":"aa bb cc eee"},"listing_type":{"val":"xxxFOR SALE","error":"aa bb cc eded"},"rental_type":{"val":"XXX","error":"aa bb XXX 3800ok"},"property_type_id":{"val":null,"error":"aa bb cc 4050"},"property_sub_type_id":{"val":null,"error":"aa bb cc 6030"},"district_id":{"val":null,"error":"aa bb cc 2767"},"estate_id":{"val":null,"error":"aa bb cc 7027"},"address":{"val":null,"error":"aa bb cc 2959"},"postal_code":{"val":null,"error":"aa bb cc 6748"},"floor":{"val":null,"error":"aa bb cc 5478"},"unit_no":{"val":null,"error":"aa bb cc 6433"},"show_unit":{"val":0,"error":"aa bb cc 3744"},"size_area":{"val":null,"error":"aa bb cc 283"},"uom":{"val":null,"error":"aa bb cc 2825"},"bedrooms":{"val":null,"error":"aa bb cc 498"},"bathrooms":{"val":null,"error":"aa bb cc 7045"},"furnishing":{"val":"","error":"aa bb cc 2695"},"floor_type":{"val":"Middle123","error":"aa bb cc 4967"},"description":{"val":"descrrr XXX","error":"aa bb cc 7331 XXX"},"listing_name":{"val":"zzzzzzzzz","error":"aa bb cc 7324"},"asking_price":{"val":null,"error":"aa bb cc 6071"},"published":{"val":0,"error":"aa bb cc 4314"},"size_unit":{"val":null,"error":"aa bb cc erer"}},"url":"/project/homedirect/user/listings/150","errors_summary":["eeoOoX","ererXXX"]});
      // setstate({ record: data.record, errors_summary: data.errors_summary });
      returnedJson = data;
   }).fail(function(jqXHR, textStatus)
    {
      // alert( 'fail');
      returnedJson = JSON.parse( jqXHR.responseText);
      // setstate( {"record":{"id":{"val":150,"error":"OOOOOO 3459"},"listing_type":{"val":"zzzFOR SALE","error":"aa bb cc 3250"},"rental_type":{"val":"zz","error":"aa bb cc OOOOOOr"},"property_type_id":{"val":null,"error":"aa bb cc 4050"},"property_sub_type_id":{"val":null,"error":"aa bb cc 6030"},"district_id":{"val":null,"error":"aa bb cc 2767"},"estate_id":{"val":null,"error":"aa bb cc 7027"},"address":{"val":null,"error":"aa bb cc 2959"},"postal_code":{"val":null,"error":"aa bb cc 6748"},"floor":{"val":null,"error":"aa bb cc 5478"},"unit_no":{"val":null,"error":"aa bb cc 6433"},"show_unit":{"val":0,"error":"aa bb cc 3744"},"size_area":{"val":null,"error":"aa bb cc 283"},"uom":{"val":null,"error":"aa bb cc 2825"},"bedrooms":{"val":null,"error":"aa bb cc 498"},"bathrooms":{"val":null,"error":"aa bb cc 7045"},"furnishing":{"val":"","error":"aa bb cc 2695"},"floor_type":{"val":"Middle123","error":"aa bb cc 4967"},"description":{"val":"descrrrRRR","error":"aa bb cc RRR"},"listing_name":{"val":"zzzzzzzzz","error":"aa bb cc 7324"},"asking_price":{"val":null,"error":"aa bb cc 6071"},"published":{"val":0,"error":"aa bb cc 4314"},"size_unit":{"val":null,"error":"aa bb cc 76"}},"url":"/project/homedirect/user/listings/150","errors_summary":["OOOOOO111","OOOOOO"]});
   }).always(function()
    {
      $('#spinner').addClass('hide');
      $("#listing_form_component").removeClass("disabled");
      setstate( returnedJson);
    });
  }

  componentWillReceiveProps(){
//    alert( 'componentWillReceiveProps componentWillReceiveProps');
  }

  componentDidUpdate( prevProps, prevState) {
    // $('html, body').animate({
    //   scrollTop: $("#errors_summary").offset().top
    // }, 0);

    if (!$('#errors_summary').hasClass('hide')) {
//      $("#listing_form_component").addClass("disabled");
      $('#errors_summary_modal .content').html( $('#errors_summary').html());
      $('#errors_summary_modal').modal('show'); // show modal
    }
  }

  componentDidMount(){
    var $location_lat = parseFloat($('#location_lat').val());
    var $location_lng = parseFloat($('#location_lng').val());
    // alert(parseFloat($location_lat));
    // alert(parseFloat($location_lng));
    var map = new google.maps.Map(document.getElementById("map"), {
        center: {lat: $location_lat, lng: $location_lng},
       zoom: 15,
       mapTypeId: 'roadmap'
     });
    
    new google.maps.Marker(
      {
        position: {lat: $location_lat, lng: $location_lng},
        map: map,
        title: this.placesSearchText()
      }
    );

    App.Util.GoogleMaps.PlacesSearchBox.setMap( map);

//    this.updateMap();
    // google.maps.event.addDomListener(window, 'load', this.updateMap);
    // //window.addEventListener("load", this.updateMap); // WERKS TOO
    // // window.addEventListener("load", this.updateMap);
    // // $(document).on("page:load", window.addEventListener("load", this.updateMap));
    // //$(document).on("turbolinks:load", window.addEventListener("load", this.updateMap));
///////******** THIS WORKS TOO ******//// ///////******** window.addEventListener("load", this.updateMap); ******////
    // document.addEventListener("turbolinks:load", this.updateMap);
    // //$(document).ready(this.updateMap);



  }
}
