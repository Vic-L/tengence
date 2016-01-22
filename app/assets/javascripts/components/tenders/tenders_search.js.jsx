var TendersSearch = React.createClass({
  handleSubmit: function(e){
    e.preventDefault();
    var url = new URI(this.props.url);
    url = url.removeQuery('page');
    var searchField = document.getElementById('query-field');
    if (searchField != null && searchField.value != '') {
      Tengence.ReactFunctions.trackQuery(searchField.value);
      this.props.getTenders(url.removeQuery('query'), searchField.value);
    } else {
      this.props.getTenders(url.removeQuery('query'));
    }
  },
  render: function(){
    return (
      <section id="search-field">
        <form onSubmit={this.handleSubmit}>
          <input name="utf8" type="hidden" value="✓" />
          <div className="row">
            <div className="medium-3 small-12 columns animated fadeInDown visible" data-animate-delay="0" data-animate="fadeInDown">
              <div className="title-section">
                <h3>Search</h3>
              </div>
            </div>
            <div className="medium-9 columns animated fadeInUp visible" data-animate-delay="0" data-animate="fadeInUp">
              <div className="row">
                <div className="small-9 medium-10 column">
                  <div className="section-desc">
                    <input type="text" name="query" id="query-field" placeholder="Search for a keyword" />
                  </div>
                </div>
                <div className="small-3 medium-2 column">
                  <div className="section-desc">
                    <button className="search-submit-button" type="submit">
                      <i className="fa fa-search"></i>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </form>
      </section>
    )
  }
});