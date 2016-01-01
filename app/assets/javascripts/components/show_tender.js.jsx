var ShowTender = React.createClass({
  revealDetails: function() {
    $('#in-house-tender-details').show();
    $('#reveal-tender-text').hide();
    $.ajax({
      url: "/viewed_tenders",
      data: {
        ref_no: "#{tender.ref_no}"
      },
      method: "POST"
    });
    $('#ga-tender-inhouse-more').parent().remove();
  },
  render: function() {
    var leftRows = [], rightRows = [];
    if (!this.props.tender.in_house) {
      leftRows.push(<ShowTenderDetail header='Reference No' body={this.props.tender.ref_no} />)
      leftRows.push(<ShowTenderDetail header='Buyer Company Name' body={this.props.tender.buyer_company_name} />);
    }
    leftRows.push(<ShowTenderDetail header='Description' body={this.props.tender.description.replace('tengence-','-')} />);
    var publishedDate = strftime('%d %b %Y', new Date(this.props.tender.published_date));
    var closingDate = strftime('%d %b %Y', new Date(this.props.tender.closing_datetime));
    var closingTime = strftime('%H:%M %p', new Date(this.props.tender.closing_datetime));
    leftRows.push(<ShowTenderDetail header='Published Date' body={publishedDate} />);
    leftRows.push(<ShowTenderDetail header='Closing Date' body={closingDate} />);
    leftRows.push(<ShowTenderDetail header='Closing Time' body={closingTime} />);
    if (this.props.tender.in_house) {
      leftRows.push(<ShowTenderDetail header='Full Description' body={this.props.tender.long_description} />);
      leftRows.push(<ShowTenderDetail header='Budget' body={this.props.tender.budget} />);
    } else {
      if (this.props.tender.gebiz) {
        leftRows.push(<ShowTenderDetail header='Original Link' body=<div><span>Step 1) Click this <a href='https://www.gebiz.gov.sg/scripts/main.do?sourceLocation=openarea&select=tenderId' className='external-link ga-tenders' target='_blank' data-gtm-category='' data-gtm-action='gebiz step 1' data-gtm-label={this.props.tender.ref_no}>link</a> to open up an instance with GeBiz. You only have to do this once per session.</span><br/><span>Step 2) Click this <a href={this.props.tender.external_link} className='external-link ga-tenders' target='_blank' id='ga-tender-gebiz-link' data-gtm-category='' data-gtm-action='outbound link' data-gtm-label={this.props.tender.ref_no}>link</a> to view this tender on Gebiz.</span></div> />);
      } else {
        leftRows.push(<ShowTenderDetail header='Original Link' body={<a target='_blank' className='ga-tenders' data-gtm-category='' data-gtm-action='outbound-link' data-gtm-label={this.props.tender.ref_no}>{this.props.tender.external_link}</a>} />);
      }
    }
    if (this.props.tender.documents[0] != null) {
      var documentRows = [];
      for (var i=0;i<this.props.tender.documents.length;i++) {
        documentRows.push(<div className='small-12 column'><a href={this.props.tender.documents[i].url}>{this.props.tender.documents[i].original_filename + ' (' + filesize(this.props.tender.documents[i].upload_size) + ')'}</a></div>);
      }
      leftRows.push(<ShowTenderDetail header='Documents' body={documentRows} />);
    }

    if (!this.props.tender.in_house) {
      rightRows.push(<ShowTenderDetail header='Buyer Name' body={this.props.tender.buyer_name} />)
      rightRows.push(<ShowTenderDetail header='Buyer Contact Number' body={this.props.tender.buyer_contact_number} />);
      rightRows.push(<ShowTenderDetail header='Buyer Email' body={this.props.tender.buyer_email} />);
    } else {
      hiddenRows = (
        <div id='in-house-tender-details'>
          <ShowTenderDetail header='Buyer Company Name' body={this.props.tender.buyer_company_name} />
          <ShowTenderDetail header='Buyer Name' body={this.props.tender.buyer_name} />
          <ShowTenderDetail header='Buyer Contact Number' body={this.props.tender.buyer_contact_number} />
          <ShowTenderDetail header='Buyer Email' body={this.props.tender.buyer_email} />
        </div>
      );
      rightRows = <ShowTenderDetail header=<span>Click <a id='ga-tender-inhouse-more' onClick={this.revealDetails} className='ga-tenders' data-gtm-category='' data-gtm-action='inhouse details' data-gtm-label={this.props.tender.ref_no}>here</a> to show details</span> body={hiddenRows} />
    }
    return (
      <div>
        <a aria-label="Close" className="close-reveal-modal">&#215;</a>
        <div className='row'>
          <div className='small-8 column main'>
            {leftRows}
          </div>
          <div className='small-4 column'>
            {rightRows}
          </div>
        </div>
      </div>
    )
  }
});