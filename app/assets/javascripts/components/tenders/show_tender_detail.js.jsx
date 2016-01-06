var ShowTenderDetail = React.createClass({
  rawMarkup: function() {
    var rawMarkup = marked(this.props.body.toString(), {sanitize: false});
    return { __html: this.props.body };
  },
  render: function(){
    return (
      <div className='row'>
        <div className='small-12 column'>
          <div className='header'>
            {this.props.header}
          </div>
        </div>
        <div className='small-12 column'>
          <div dangerouslySetInnerHTML={this.rawMarkup()}></div>
        </div>
      </div>
    )
  }
});