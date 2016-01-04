var ShowTenderDetail = React.createClass({
  render: function(){
    return (
      <div className='row'>
        <div className='small-12 column'>
          <div className='header'>
            {this.props.header}
          </div>
        </div>
        <div className='small-12 column'>
          {this.props.body}
        </div>
      </div>
    )
  }
});