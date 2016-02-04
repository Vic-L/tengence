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
  render: function() {
    var refNo, description, longDescription, buyerCompanyName, buyerName, buyerEmail, buyerContactNumber, originalLink, documents, documentRows=[], publishedDate, closingDate, closingTime;
    refNo = <ShowTenderDetail header='Reference No' body={this.props.tender.ref_no.replace('tengence-','-')} />;
    buyerCompanyName = <ShowTenderDetail header='Buyer Company Name' body={this.props.tender.buyer_company_name} />;
    if (this.props.tender.buyer_name != null && this.props.tender.buyer_name != '') {
      buyerName = <ShowTenderDetail header='Buyer Name' body={this.props.tender.buyer_name} />;
    }
    if (this.props.tender.buyer_contact_number != null && this.props.tender.buyer_contact_number != '') {
      buyerContactNumber = <ShowTenderDetail header='Buyer Contact Number' body={this.props.tender.buyer_contact_number} />;
    }
    if (this.props.tender.buyer_email != null && this.props.tender.buyer_email != '') {
      buyerEmail = <ShowTenderDetail header='Buyer Email' body={this.props.tender.buyer_email} />;
    }
    description = <ShowTenderDetail header='Description' body={this.props.tender.description} />;
    published_date = <ShowTenderDetail header='Published Date' body={strftime.timezone('+0000')('%d %b %Y', new Date(this.props.tender.published_date))} />;
    closingDate = <ShowTenderDetail header='Closing Date' body={strftime.timezone('+0000')('%d %b %Y', new Date(this.props.tender.closing_datetime))} />;
    closingTime = <ShowTenderDetail header='Closing Time' body={strftime.timezone('+0000')('%H:%M %p', new Date(this.props.tender.closing_datetime))} />;

    if (this.props.tender.in_house) {
      longDescription = <ShowTenderDetail header='Full Description' body={this.props.tender.long_description.replace(/\n/g,'<br/>')} />;
    } else {
      var body = "<a href='" + this.props.tender.external_link + "' target='_blank' class='ga-tenders' data-gtm-category='' data-gtm-action='outbound-link' data-gtm-label='" + this.props.tender.ref_no + "'>" + this.props.tender.external_link + "</a>";
      originalLink = <ShowTenderDetail header='Original Link' body={body} extraClass='external-link'/>;
    }

    if (this.props.tender.documents[0] != null) {
      var documentRows = [];
      for (var i=0;i<this.props.tender.documents.length;i++) {
        if (i !== 0) documentRows.push(<br/>);
        documentRows.push(<a target='_blank' href={this.props.tender.documents[i].url}>{this.props.tender.documents[i].original_filename + ' (' + filesize(this.props.tender.documents[i].upload_size) + ')'}</a>);
      }
      if (documentRows.size > 0) {
        documents = (
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
      }
    }

    if (Tengence.ReactFunctions.finished_trial_but_yet_to_subscribe(this.props.trial_tenders_count)) {
      if (this.props.tender.in_house) {
        return (
          <div>
            <a aria-label="Close" className="close-reveal-modal">&#215;</a>
            <div className='row'>
              <div className='medium-12 column'>
                {refNo}
                {buyerCompanyName}
                <a id='ga-tender-inhouse-more' onClick={this.revealDetails} className='ga-tenders' data-gtm-category='' data-gtm-action='inhouse details' data-gtm-label={refNo}>Show buyer details</a>
                <div id='in-house-tender-details'>
                  {buyerName}
                  {buyerContactNumber}
                  {buyerEmail}
                </div>
                {published_date}
                {closingDate}
                {closingTime}
                {description}
                {longDescription}
                {documents}
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
                {refNo}
                {buyerCompanyName}
                {buyerName}
                {buyerContactNumber}
                {buyerEmail}
                {published_date}
                {closingDate}
                {closingTime}
                {description}
                {originalLink}
              </div>
            </div>
          </div>
        )
      }
    } else {
      if (this.props.tender.in_house) {
        return (
          <div>
            <a aria-label="Close" className="close-reveal-modal">&#215;</a>
            <div className='row'>
              <div className='medium-12 column'>
                {refNo}
                {buyerCompanyName}
                {buyerName}
                {buyerContactNumber}
                {buyerEmail}
                {published_date}
                {closingDate}
                {closingTime}
                {description}
                {longDescription}
                {documents}
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
                {refNo}
                {buyerCompanyName}
                {buyerName}
                {buyerContactNumber}
                {buyerEmail}
                {published_date}
                {closingDate}
                {closingTime}
                {description}
                {originalLink}
              </div>
            </div>
          </div>
        )
      }
    }
  }
});