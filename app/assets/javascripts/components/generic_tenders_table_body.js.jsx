var GenericTendersTableBody = React.createClass({
  render: function() {
    var rows = [];
    for (var i=0; i < this.props.tenders.length; i++) {
      var closingDate = strftime('%d %b %Y', new Date(this.props.tenders[i].closing_datetime));
      var publishedDate = strftime('%d %b %Y', new Date(this.props.tenders[i].published_date));
      var closingTime = strftime('%H:%M %p', new Date(this.props.tenders[i].closing_datetime))
      rows.push(<GenericTenderRow refNo={this.props.tenders[i].ref_no} description={this.props.tenders[i].description} publishedDate={publishedDate} closingDate={closingDate} closingTime={closingTime} buyerCompanyName={this.props.tenders[i].buyer_company_name}/>);
    }
    return (
      <tbody>
        {rows}
      </tbody>
    );
  }
});