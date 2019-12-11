import React from 'react';
import './Dashboard.scss';
import { Link } from 'react-router-dom';



function Header() {
    return (
        <header className="container  app-header">
            <h1>Marceline</h1>
            <span>
                <i className="far fa-user" />
                <i className="fas fa-search"></i>
                <i className="fas fa-cog" />
            </span>
        </header>
    )
}



function Dashboard() {
    return (
        <div className="container ">
            <Header />
            <div className="container main-container">
                <div className="columns box-column">
                    <div className="column">
                        <div className="card weather-box">
                            <h3>Today</h3>
                            <i className="fas fa-cloud-showers-heavy" />
                            <p>18°</p>
                        </div>
                    </div>
                    <div className="column">
                        <div className="card archive-box">
                            <i className="fas fa-archive" />
                            <p>0 archived Notes</p>
                        </div>
                    </div>
                    <div className="column">
                        <div className="card finished-box">
                            <i className="fas fa-tasks" />
                            <p>0 finished tasks</p>
                        </div>
                    </div>
                    <div className="column">
                        <div className="card historic-box">
                            <i className="far fa-bookmark" />
                            <p>favorites Url</p>
                        </div>
                    </div>
                </div>
                <div className="vertical-space"></div>
                <div className="columns">
                    <div className="column is-three-fifths">
                        <div className="card">
                            <div className="card-header note-header">
                                <h2>
                                    <i className="far fa-sticky-note" />
                                    My Notes
                                </h2>
                            </div>
                            <div className="card-body main-note-body">
                                this is the place of the notes
                            </div>
                        </div>
                        <div className="vertical-space"></div>
                        <div className="card ">
                            <div className="card-header news-header">
                                <h2>
                                    <i className="fas fa-newspaper" />
                                    Latest Article
                                </h2>
                            </div>
                            <div className="card-body main-card-body">
                                <div className="menu-panel">
                                    <span>News</span>
                                    <span>Sport</span>
                                    <span>Finance</span>
                                    <span>Lifestyle</span>
                                    <span>Food</span>
                                    <span>Sport</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="space"></div>
                    <div className="column right-side">
                        <div className="card" style={{ marginBottom: '10%' }}>
                            <div className="card-header calendar-header">
                                <h2>
                                    <i className="far fa-calendar" />
                                    calendar
                                </h2>
                            </div>
                        </div>

                        <div className="card" style={{ marginBottom: '10%' }}>
                            <div className="card-header contact-header">
                                <h2>
                                    <i className="far fa-address-book" />
                                    Contact
                                </h2>
                            </div>
                            <div className="card-body">
                                <a href="#">
                                    <i className="fas fa-users" />
                                    Family
                                </a>
                                <a href="#">
                                    <i className="fas fa-briefcase" />
                                    Coworker
                                </a>
                                <a href="#">
                                    <i class="fas fa-ambulance" />
                                    Emergency
                                </a>
                                <a href="#">
                                    <i className="fas fa-user-friends" />
                                    Friends
                                </a>
                                <a href="#">
                                    <i className="fas fa-ellipsis-h" />
                                    More
                                </a>
                            </div>
                            <div className="card-footer">
                                <a href="#">
                                    <i class="fas fa-plus" />
                                </a>
                                <a href="#">
                                    <i className="far fa-eye" />
                                </a>
                            </div>
                        </div>

                        <div className="card">
                            <div className="card-header todo-header">
                                <h2>
                                    <i className="far fa-check-square" />
                                    To-Do
                                </h2>
                            </div>
                            <div className="card-body">
                                <a href="#">
                                    <i className="far fa-sun" />
                                    Today
                                </a>
                                <a href="#">
                                    <i className="far fa-star" />
                                    Important
                                </a>
                                <a href="#">
                                    <i className="far fa-calendar-alt" />
                                    Planned
                                </a>
                                <a href="#">
                                    <i className="far fa-list-alt" />
                                    Tasks
                                </a>
                            </div>
                            <div className="card-body">
                                <ul>
                                    <span>
                                        <li>
                                            <label className="checkbox">
                                                <input type="checkbox" />
                                                Remember me
                                                <span class="checkmark"></span>
                                            </label>
                                        </li>
                                    </span>
                                    <span>
                                        <li>
                                            <label className="checkbox">
                                                <input type="checkbox" />
                                                Remember me
                                            </label>
                                        </li>
                                    </span>
                                    <span>
                                        <li>
                                            <label className="checkbox">
                                                <input type="checkbox" />
                                                Remember me
                                            </label>
                                        </li>
                                    </span>
                                    <span>
                                        <li>
                                            <label className="checkbox">
                                                <input type="checkbox" />
                                                Remember me
                                            </label>
                                        </li>
                                    </span>
                                </ul>
                            </div>
                            <div className="card-footer">
                                <a href="#">
                                    <i class="fas fa-plus" />
                                </a>
                                <a href="#">
                                    <i className="far fa-eye" />
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="vertical-space"></div>
                <div className="columns">
                    <div className="column">
                        <div className="card">
                            <div className="card-header">
                                <h2>
                                    Carculator
                                </h2>
                            </div>
                        </div>
                    </div>
                    <div className="column">
                        <div className="card">
                            <div className="card-header">
                                <h2>
                                    Currency
                                </h2>
                            </div>
                        </div>
                    </div>
                    <div className="column">
                        <div className="card">
                            <div className="card-header">
                                <h2>
                                    translator
                                </h2>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default Dashboard; 