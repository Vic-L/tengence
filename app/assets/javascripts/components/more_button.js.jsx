var MoreButton = React.createClass({
  render: function() {
    return (
      <div>
        <a href={this.props.showPath} data-remote='true' data-method='get' className='button more-button ga-tenders' data-gtm-category='' data-gtm-action='more' data-gtm-label={this.props.refNo}>More</a>
      </div>
    );
  }
});