var GenericTenderRow = React.createClass({
  render: function() {
    var watchlistButton;
    if (this.props.watched) {
      watchlistButton = <UnwatchButton showLoading={this.props.showLoading} unwatchPath={this.props.unwatchPath} refNo={this.props.refNo} unwatchTender={this.props.unwatchTender}/>;
    } else {
      watchlistButton = <WatchButton showLoading={this.props.showLoading} watchPath={this.props.watchPath} refNo={this.props.refNo} watchTender={this.props.watchTender}/>;
    };
    return (
      <tr>
        <td>{this.props.description}</td>
        <td>{this.props.publishedDate}</td>
        <td>{this.props.closingDate}</td>
        <td>{this.props.closingTime}</td>
        <td>{this.props.buyerCompanyName}</td>
        <td>{watchlistButton}</td>
        <td><MoreButton showTender={this.props.showTender} showPath={this.props.showPath} refNo={this.props.refNo}/></td>
      </tr>
    );
  }
});
