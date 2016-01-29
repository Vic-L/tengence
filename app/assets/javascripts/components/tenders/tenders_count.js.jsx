var TendersCount = React.createClass({
  render: function (){
    return (
      <section id="hero">
        <div className="row">
          <div className="small-12 medium-6 column text-center">
            <div className="counter animated" data-perc={this.props.current_tenders_count}>
              <div className="number-detail">
                <h2>
                  <div className="number"></div>
                  <div className="text">Current Tenders</div>
                </h2>
              </div>
            </div>
          </div>
          <div className="small-12 medium-6 column text-center">
            <div className="counter animated" data-perc="62">
              <div className="number-detail">
                <h2>
                  <div className="number"></div>
                  <div className="text">Tender Sources and counting</div>
                </h2>
              </div>
            </div>
          </div>
        </div>
      </section>
    );
  }
});