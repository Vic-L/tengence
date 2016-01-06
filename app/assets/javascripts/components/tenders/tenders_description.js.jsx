var TendersDescription = React.createClass({
  render: function(){
    return (
      <section id="description">
        <div className="row">
          <div className="small-12 column">
            {this.props.descriptionText}            
          </div>
        </div>
      </section>
    );
  }
});