var GenericTendersTableBody = React.createClass({
  render: function() {
    var rows = [];
    for (var i=0; i < this.props.tenders.length; i++) {
      var closingDate = strftime('%d %b %Y', new Date(this.props.tenders[i].closing_datetime));
      var publishedDate = strftime('%d %b %Y', new Date(this.props.tenders[i].published_date));
      var closingTime = strftime('%H:%M %p', new Date(this.props.tenders[i].closing_datetime))
      rows.push(<GenericTenderRow showLoading={this.props.showLoading} refNo={this.props.tenders[i].ref_no} description={this.props.tenders[i].description} publishedDate={publishedDate} closingDate={closingDate} closingTime={closingTime} buyerCompanyName={this.props.tenders[i].buyer_company_name} watchPath={this.props.tenders[i].watch_path} unwatchPath={this.props.tenders[i].unwatch_path} watched={this.props.tenders[i].watched} showPath={this.props.tenders[i].show_path} watchTender={this.props.watchTender} unwatchTender={this.props.unwatchTender}/>);
    }
    return (
      <tbody>
        {rows}
      </tbody>
    );
  }
});