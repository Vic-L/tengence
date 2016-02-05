var WatchedTenderRow = React.createClass({
  render: function() {
    var watchlistButton;
    if (this.props.watched) {
      watchlistButton = <UnwatchButton {...this.props} />;
    } else {
      watchlistButton = <WatchButton {...this.props} />;
    };
    if (Tengence.ReactFunctions.finished_trial_but_yet_to_subscribe(this.props.trial_tender_ids)){
      return (
        <tr>
          <td><input name="select_single[]" type="checkbox" value={this.props.refNo} /></td>
          <td>{this.props.status}</td>
          <td>{this.props.description}</td>
          <td>{this.props.publishedDate}</td>
          <td>{this.props.closingDate}</td>
          <td>{this.props.closingTime}</td>
          <td>{watchlistButton}</td>
          <td><MoreButton parentComponent={this.props.parentComponent} trial_tender_ids={this.props.trial_tender_ids} refNo={this.props.refNo}/></td>
        </tr>
      );
    } else {
      return (
        <tr>
          <td><input name="select_single[]" type="checkbox" value={this.props.refNo} /></td>
          <td>{this.props.status}</td>
          <td>{this.props.description}</td>
          <td>{this.props.publishedDate}</td>
          <td>{this.props.closingDate}</td>
          <td>{this.props.closingTime}</td>
          <td>{this.props.buyerCompanyName}</td>
          <td>{watchlistButton}</td>
          <td><MoreButton parentComponent={this.props.parentComponent} trial_tender_ids={this.props.trial_tender_ids} refNo={this.props.refNo}/></td>
        </tr>
      );
    }
  }
});
