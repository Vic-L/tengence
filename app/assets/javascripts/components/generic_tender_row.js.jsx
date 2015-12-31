var GenericTenderRow = React.createClass({
  propTypes: {
    refNo: React.PropTypes.string,
    description: React.PropTypes.string,
    publishedDate: React.PropTypes.string,
    closingDate: React.PropTypes.string,
    closingTime: React.PropTypes.string,
    buyerCompanyName: React.PropTypes.string,
    watched: React.PropTypes.bool,
    showPath: React.PropTypes.string,
    watchPath: React.PropTypes.string
  },


  render: function() {
    var watchlistButton;
    if (this.props.watched) {
      watchlistButton = <UnwatchButton unwatchPath={this.props.watchPath} refNo={this.props.refNo} />;
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
