var GenericTenderRow = React.createClass({
  render: function() {
    var watchlistButton;
    if (this.props.watched) {
      watchlistButton = <UnwatchButton unwatchPath={this.props.unwatchPath} refNo={this.props.refNo} />;
    } else {
      watchlistButton = <WatchButton watchPath={this.props.watchPath} refNo={this.props.refNo} />;
    };
    return (
      <tr>
        <td className='medium-5'>{this.props.description}</td>
        <td className='medium-1'>{this.props.publishedDate}</td>
        <td className='medium-1'>{this.props.closingDate}</td>
        <td className='medium-1'>{this.props.closingTime}</td>
        <td className='medium-2'>{this.props.buyerCompanyName}</td>
        <td className='medium-1'>{watchlistButton}</td>
        <td className='medium-1'><a href=''>More</a></td>
      </tr>
    );
  }
});
