var UnwatchButton = React.createClass({
  render: function() {
    var id = "watch-tender-" + this.props.refNo;
    return (
      <div id={id}>
        <a href={this.props.unwatchPath} data-remote='true' data-method='delete' className='button unwatch-button ga-tenders' data-gtm-category='' data-gtm-action='unwatch' data-gtm-label={this.props.refNo}>Unwatch</a>
      </div>
    );
  }
});