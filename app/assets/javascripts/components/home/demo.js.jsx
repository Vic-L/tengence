var Demo = React.createClass({
  getInitialState: function() {
    return {tenders: [], pagination: {}, results_count: null, url: this.props.url, keywords: this.props.keywords};
  },
  componentDidMount: function() {
    this.getTenders(this.state.url, null);
  },
  getTenders: function(url, page, table, query, keywords, sort){
    Tengence.ReactFunctions.getTenders(this, url, page, table, query, keywords, sort);
  },
  render: function(){
    return (
      <section id='demo'>
        <div className="row">
          <div className="subtitle">
            <h2>Demo<span className="color">.</span></h2>
            <p>Get a feel for what Tengence has to offer.</p>
            <p>Search for currently open tenders in our database based on keywords relevant to your business.</p>
          </div>
        </div>
        <TendersSearch getTenders={this.getTenders} url={this.state.url}/>
        <DemoTendersResults url={this.state.url} pagination={this.state.pagination} results_count={this.state.results_count} getTenders={this.getTenders} tenders={this.state.tenders} parentComponent={this} />
      </section>
    )
  }
});