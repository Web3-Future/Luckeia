import { useEffect } from 'react';

const AboutPage: React.FC = () => {
    // useEffect(() => {
    //     const script = document.createElement('script');
    //     script.src = '/script.js';
    //     script.async = true;
    //     document.body.appendChild(script);
    //     return () => {
    //         document.body.removeChild(script);
    //     };
    // }, []);


    return (
        <div id="fluid-container">
            <h1>About Page</h1>
            <p>This is the about page of our application.</p>
            <iframe src="/index.html" frameBorder="0"></iframe>
        </div>
    );
};

export default AboutPage;
