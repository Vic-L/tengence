var ShowTender = React.createClass({
  revealDetails: function() {
    $('#in-house-tender-details').show();
    $('#ga-tender-inhouse-more').remove();
    $.ajax({
      url: "/viewed_tenders",
      data: {
        ref_no: this.props.tender.ref_no
      },
      method: "POST"
    });
  },
  revealBoughtDetails: function(){
    $('#buy-details-notice').remove();
    ReactDOM.render((<div>
        {this.getBuyerCompanyName()}
        {this.getBuyerName()}
        {this.getBuyerContactNumber()}
        {this.getBuyerEmail()}
        {this.getOriginalLink()}
        {this.getDocuments()}
      </div>), document.getElementById('buyer-details')
    );
  },
  buyDetails: function() {
    $.ajax({
      url: "/trial_tenders",
      data: {
        ref_no: this.props.tender.ref_no
      },
      method: "POST",
      success: function(data){
        if (data !== 'ignore') {
          this.props.parentComponent.setState({trial_tender_ids: data});
        }
      }.bind(this),
      error: function(xhr, status, err){
        Tengence.ReactFunctions.notifyError(window.location.href,'buyDetails', xhr.statusText)
      }
    });
    this.revealBoughtDetails();
  },
  getRefNo: function(){
    return <ShowTenderDetail header='Reference No' body={this.props.tender.ref_no.replace('tengence-','')} />;
  },
  getBuyerCompanyName: function(){
    return <ShowTenderDetail header='Buyer Company Name' body={this.props.tender.buyer_company_name} />;
  },
  getBuyerName: function(){
    if (this.props.tender.buyer_name != null && this.props.tender.buyer_name != '') {
      return <ShowTenderDetail header='Buyer Name' body={this.props.tender.buyer_name} />;
    } else {
      return null;
    }
  },
  getBuyerContactNumber: function(){
    if (this.props.tender.buyer_contact_number != null && this.props.tender.buyer_contact_number != '') {
      return <ShowTenderDetail header='Buyer Contact Number' body={this.props.tender.buyer_contact_number} />;
    } else {
      return null;
    }
  },
  getBuyerEmail: function(){
    if (this.props.tender.buyer_email != null && this.props.tender.buyer_email != '') {
      buyerEmail = <ShowTenderDetail header='Buyer Email' body={this.props.tender.buyer_email} />;
    } else {
      return null;
    }
  },
  getDescription: function(){
    return <ShowTenderDetail header='Description' body={this.props.tender.description} />;
  },
  getPublished_date: function(){
    return  <ShowTenderDetail header='Published Date' body={strftime.timezone('+0000')('%d %b %Y', new Date(this.props.tender.published_date))} />;
  },
  getClosingDate: function(){
    return  <ShowTenderDetail header='Closing Date' body={strftime.timezone('+0000')('%d %b %Y', new Date(this.props.tender.closing_datetime))} />;
  },
  getClosingTime: function(){
    return  <ShowTenderDetail header='Closing Time' body={strftime.timezone('+0000')('%H:%M %p', new Date(this.props.tender.closing_datetime))} />;
  },
  getLongDescription: function() {
    if (this.props.tender.in_house) {
      return <ShowTenderDetail header='Full Description' body={this.props.tender.long_description.replace(/\n/g,'<br/>')} />;
    } else {
      return null;
    }
  },
  getOriginalLink: function(){
    if (this.props.tender.external_link != null && this.props.tender.external_link != '') {
      var body = "<a href='" + this.props.tender.external_link + "' target='_blank' class='ga-tenders' data-gtm-category='' data-gtm-action='outbound-link' data-gtm-label='" + this.props.tender.ref_no + "'>" + this.props.tender.external_link + "</a>";
      return <ShowTenderDetail header='Original Link' body={body} extraClass='external-link'/>;
    } else {
      return null;
    }
  },
  getDocuments: function(){
    if (this.props.tender.documents[0] != null) {
      var documentRows = [];
      for (var i=0;i<this.props.tender.documents.length;i++) {
        if (i !== 0) documentRows.push(<br/>);
        documentRows.push(<a target='_blank' href={this.props.tender.documents[i].url}>{this.props.tender.documents[i].original_filename + ' (' + filesize(this.props.tender.documents[i].upload_size) + ')'}</a>);
      }
      if (documentRows.size > 0) {
        return (
          <div className='row'>
            <div className='small-12 column'>
              <div className='header'>
                Documents
              </div>
            </div>
            <div className='small-12 column'>
              {documentRows}
            </div>
          </div>);
      } else {
        return null;
      }
    } else {
      return null;
    }
  },
  render: function() {

    if (Tengence.ReactFunctions.tenderAlreadyUnlocked(this.props.trial_tender_ids, this.props.tender.ref_no)) {

      if (this.props.tender.in_house) {

          return (
            <div>
              <a aria-label="Close" className="close-reveal-modal">&#215;</a>
              <div className='row'>
                <div className='medium-12 column'>
                  {this.getRefNo()}
                  {this.getPublished_date()}
                  {this.getClosingDate()}
                  {this.getClosingTime()}
                  {this.getDescription()}
                  {this.getLongDescription()}
                  {this.getOriginalLink()}
                  {this.getDocuments()}
                  <hr/>
                  <a id='ga-tender-inhouse-more' onClick={this.revealDetails} className='ga-tenders' data-gtm-category='' data-gtm-action='inhouse details' data-gtm-label={this.props.tender.ref_no}>Show buyer details</a>
                  <div id='in-house-tender-details'>
                    {this.getBuyerCompanyName()}
                    {this.getBuyerName()}
                    {this.getBuyerContactNumber()}
                    {this.getBuyerEmail()}
                  </div>
                </div>
              </div>
            </div>
          )

      } else {

        return (
          <div>
            <a aria-label="Close" className="close-reveal-modal">&#215;</a>
            <div className='row'>
              <div className='medium-12 column'>
                {this.getRefNo()}
                {this.getBuyerCompanyName()}
                {this.getDescription()}
                {this.getPublished_date()}
                {this.getClosingDate()}
                {this.getClosingTime()}
                {this.getLongDescription()}
                <hr/>
                {this.getBuyerName()}
                {this.getBuyerContactNumber()}
                {this.getBuyerEmail()}
                {this.getOriginalLink()}
                {this.getDocuments()}
              </div>
            </div>
          </div>
        )

      }

    } else {

      if (Tengence.ReactFunctions.finishedTrialButYetToSubscribe(this.props.trial_tender_ids)) {

        if (this.props.trial_tender_ids.length >= 3) {

          return (
            <div>
              <a aria-label="Close" className="close-reveal-modal">&#215;</a>
              <div className='row'>
                <div className='medium-12 column'>
                  {this.getRefNo()}
                  {this.getDescription()}
                  {this.getPublished_date()}
                  {this.getClosingDate()}
                  {this.getClosingTime()}
                  {this.getLongDescription()}
                  <hr/>
                  You have used up your credits for the day to unlock business leads.
                  <br/>
                  To get UNLIMITED access to ALL tenders on Tengence, <a href='/subscribe' className='ga-tenders' data-gtm-category='' data-gtm-action='prompt subscribe' data-gtm-label={this.props.tender.ref_no}>SUBSCRIBE now</a>!
                </div>
              </div>
            </div>
          )

        } else {

          return (
            <div>
              <a aria-label="Close" className="close-reveal-modal">&#215;</a>
              <div className='row'>
                <div className='medium-12 column'>
                  {this.getRefNo()}
                  {this.getDescription()}
                  {this.getPublished_date()}
                  {this.getClosingDate()}
                  {this.getClosingTime()}
                  {this.getLongDescription()}
                  <hr/>
                  <div id='buyer-details'></div>
                  <span id='buy-details-notice'>
                  <a id='buy-details' onClick={this.buyDetails} className='ga-tenders' data-gtm-category='' data-gtm-action='buy details' data-gtm-label={this.props.tender.ref_no}>Reveal buyer details with 1 credit</a> (You have {3 - this.props.trial_tender_ids.length} credits left for the day)
                  </span>
                </div>
              </div>
            </div>
          )

        }

      } else {

        if (Tengence.ReactFunctions.isPostedTendersPage()) {

          return (
            <div>
              <a aria-label="Close" className="close-reveal-modal">&#215;</a>
              <div className='row'>
                <div className='medium-12 column'>
                  {this.getRefNo()}
                  {this.getBuyerCompanyName()}
                  {this.getDescription()}
                  {this.getPublished_date()}
                  {this.getClosingDate()}
                  {this.getClosingTime()}
                  {this.getLongDescription()}
                  <hr/>
                  {this.getBuyerName()}
                  {this.getBuyerContactNumber()}
                  {this.getBuyerEmail()}
                  {this.getOriginalLink()}
                  {this.getDocuments()}
                </div>
              </div>
            </div>
          )

        } else if (this.props.tender.in_house) {

          return (
            <div>
              <a aria-label="Close" className="close-reveal-modal">&#215;</a>
              <div className='row'>
                <div className='medium-12 column'>
                  {this.getRefNo()}
                  {this.getPublished_date()}
                  {this.getClosingDate()}
                  {this.getClosingTime()}
                  {this.getDescription()}
                  {this.getLongDescription()}
                  {this.getOriginalLink()}
                  {this.getDocuments()}
                  <hr/>
                  <a id='ga-tender-inhouse-more' onClick={this.revealDetails} className='ga-tenders' data-gtm-category='' data-gtm-action='inhouse details' data-gtm-label={this.props.tender.ref_no}>Show buyer details</a>
                  <div id='in-house-tender-details'>
                    {this.getBuyerCompanyName()}
                    {this.getBuyerName()}
                    {this.getBuyerContactNumber()}
                    {this.getBuyerEmail()}
                  </div>
                </div>
              </div>
            </div>
          )

        } else {

          return (
            <div>
              <a aria-label="Close" className="close-reveal-modal">&#215;</a>
              <div className='row'>
                <div className='medium-12 column'>
                  {this.getRefNo()}
                  {this.getBuyerCompanyName()}
                  {this.getDescription()}
                  {this.getPublished_date()}
                  {this.getClosingDate()}
                  {this.getClosingTime()}
                  {this.getLongDescription()}
                  <hr/>
                  {this.getBuyerName()}
                  {this.getBuyerContactNumber()}
                  {this.getBuyerEmail()}
                  {this.getOriginalLink()}
                  {this.getDocuments()}
                </div>
              </div>
            </div>
          )

        }
      }

    }
  }
});