var UnwatchButton = React.createClass({
  render: function() {
    return (
      <a href={this.props.watchPath} data-remote='true' data-method='delete' className='button unwatch-button ga-tenders' data-gtm-category='' data-gtm-action='unwatch' data-gtm-label={this.props.refNo}>Unwatch</a>
    );
  }
});