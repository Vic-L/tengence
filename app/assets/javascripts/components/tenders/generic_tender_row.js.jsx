var GenericTenderRow = React.createClass({
  render: function() {
    var watchlistButton;
    if (this.props.watched) {
      watchlistButton = <UnwatchButton {...this.props} />;
    } else {
      watchlistButton = <WatchButton {...this.props} />;
    };
    if (Tengence.ReactFunctions.finished_trial_but_yet_to_subscribe(this.props.trial_tenders_count)){
      return (
        <tr>
          <td>{this.props.description}</td>
          <td>{this.props.publishedDate}</td>
          <td>{this.props.closingDate}</td>
          <td>{this.props.closingTime}</td>
          <td>{watchlistButton}</td>
          <td><MoreButton parentComponent={this.props.parentComponent} trial_tenders_count={this.props.trial_tenders_count} refNo={this.props.refNo}/></td>
        </tr>
      );
    } else {
      return (
        <tr>
          <td>{this.props.description}</td>
          <td>{this.props.publishedDate}</td>
          <td>{this.props.closingDate}</td>
          <td>{this.props.closingTime}</td>
          <td>{this.props.buyerCompanyName}</td>
          <td>{watchlistButton}</td>
          <td><MoreButton parentComponent={this.props.parentComponent} trial_tenders_count={this.props.trial_tenders_count} refNo={this.props.refNo}/></td>
        </tr>
      );
    }
  }
});
