var ShowTender = React.createClass({
  revealDetails: function() {
    $('#in-house-tender-details').show();
    $('#reveal-tender-text').hide();
    $.ajax({
      url: "/viewed_tenders",
      data: {
        ref_no: this.props.tender.ref_no
      },
      method: "POST"
    });
    $('#ga-tender-inhouse-more').parent().remove();
  },
  populateLeftColumn: function(){
    var leftRows = [];
    if (!this.props.tender.in_house) {
      leftRows.push(<ShowTenderDetail header='Reference No' body={this.props.tender.ref_no.replace('tengence-','-')} />)
      leftRows.push(<ShowTenderDetail header='Buyer Company Name' body={this.props.tender.buyer_company_name} />);
    }
    leftRows.push(<ShowTenderDetail header='Description' body={this.props.tender.description} />);
    var publishedDate = strftime.timezone('+0000')('%d %b %Y', new Date(this.props.tender.published_date));
    var closingDate = strftime.timezone('+0000')('%d %b %Y', new Date(this.props.tender.closing_datetime));
    var closingTime = strftime.timezone('+0000')('%H:%M %p', new Date(this.props.tender.closing_datetime));
    leftRows.push(<ShowTenderDetail header='Published Date' body={publishedDate} />);
    leftRows.push(<ShowTenderDetail header='Closing Date' body={closingDate} />);
    leftRows.push(<ShowTenderDetail header='Closing Time' body={closingTime} />);
    if (this.props.tender.in_house) {
      leftRows.push(<ShowTenderDetail header='Full Description' body={this.props.tender.long_description.replace(/\n/g,'<br/>')} />);
    } else {
      var body = '';
      body = "<a href='" + this.props.tender.external_link + "' target='_blank' class='ga-tenders' data-gtm-category='' data-gtm-action='outbound-link' data-gtm-label='" + this.props.tender.ref_no + "'>" + this.props.tender.external_link + "</a>"
      leftRows.push(<ShowTenderDetail header='Original Link' body={body} />);
    }
    if (this.props.tender.documents[0] != null) {
      var documentRows = [];
      for (var i=0;i<this.props.tender.documents.length;i++) {
        if (i !== 0) documentRows.push(<br/>);
        documentRows.push(<a target='_blank' href={this.props.tender.documents[i].url}>{this.props.tender.documents[i].original_filename + ' (' + filesize(this.props.tender.documents[i].upload_size) + ')'}</a>);
      }
      leftRows.push(<div className='row'>
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
    return leftRows;
  },
  populateRightColumn: function(){
    var rightRows = [];
    if (!this.props.tender.in_house) {
      rightRows.push(<ShowTenderDetail header='Buyer Name' body={this.props.tender.buyer_name} />)
      rightRows.push(<ShowTenderDetail header='Buyer Contact Number' body={this.props.tender.buyer_contact_number} />);
      rightRows.push(<ShowTenderDetail header='Buyer Email' body={this.props.tender.buyer_email} />);
    } else {
      var hiddenRows = (
        <div id='in-house-tender-details'>
          <ShowTenderDetail header='Buyer Company Name' body={this.props.tender.buyer_company_name} />
          <ShowTenderDetail header='Buyer Name' body={this.props.tender.buyer_name} />
          <ShowTenderDetail header='Buyer Contact Number' body={this.props.tender.buyer_contact_number} />
          <ShowTenderDetail header='Buyer Email' body={this.props.tender.buyer_email} />
        </div>
      );
      rightRows = (
        <div className='row'>
          <div className='small-12 column'>
            <div className='header'>
              <span>Click <a id='ga-tender-inhouse-more' onClick={this.revealDetails} className='ga-tenders' data-gtm-category='' data-gtm-action='inhouse details' data-gtm-label={this.props.tender.ref_no}>here</a> to show details</span>
            </div>
          </div>
          <div className='small-12 column'>
            {hiddenRows}
          </div>
        </div>
      )
    }
    return rightRows;
  },
  render: function() {
    return (
      <div>
        <a aria-label="Close" className="close-reveal-modal">&#215;</a>
        <div className='row'>
          <div className='small-8 column main'>
            {this.populateLeftColumn()}
          </div>
          <div className='small-4 column'>
            {this.populateRightColumn()}
          </div>
        </div>
      </div>
    )
  }
});