<%@ page session="false"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<jsp:include page="base.jsp" />


<body>
<!-- Help Tab -->
        <!--Section header-->
        <h2>Just Getting Started with IPT?</h2>
        <!--Links-->
        <h4><a href="https://diagrid.org/resources/ipt/about" target="_blank"
               alt="Interactive Parallelization Tool (IPT)">Interactive Parallelization Tool (IPT)</a></h4>

        <p>Interactive Parallelization Tool (IPT) is a high-level tool for transforming serial C/C++ applications
          into their parallel variants. The parallel programming models that are currently supported by IPT are:
          MPI, OpenMP, CUDA, and Hybrid Programming models. The end-users of IPT must have an understanding
          of the basic concepts involved in parallel programming (e.g., data distribution and data gathering).
          After developing an understanding of the basic parallel programming concepts,
          IPT can be used by its target audience (domain experts and students) to semi-automatically generate
          parallel programs based on multiple parallel programming paradigms (MPI, OpenMP, and CUDA), and
          learn about these paradigms through observation and comparison. The IPT-based personalized learning
          approach complements the traditional methods of learning and training that usually emphasize the syntax
          and semantics of one or more programming standards. IPT provides a jumpstart to the domain experts
          in using modern High Performance Computing (HPC) platforms for their research and development needs,
          and hence lowers the adoption barriers to HPC.</p>
        <h4>
          For further high-level details related to IPT (motivation, design, benefits), please review our
            <a href="http://dl.acm.org/citation.cfm?id=2616558" target="_blank" alt="A Tool for Interactive Parallelization">paper</a>.
        </h4>

        <!--Section header-->
        <h2>Want to Learn More?</h2>
        <!--Links-->
        <h4><a href="{% static 'supportdocs/trainingIPT.zip' %}" target="_blank" alt="Tutorial Files for IPT">Tutorial
            Files for IPT</a></h4>

        <p>Some test cases and the step-by-step process of parallelizing those test cases using IPT can be downloaded
        <a href={% static 'supportdocs/trainingIPT.zip' %} target="_blank" alt="IPT user guide">here</a>.</p>

        <h4><a href="{% static 'supportdocs/User_Guide_1.0.pdf' %}" target="_blank" alt="IPT user guide">IPT User
            Guide</a></h4>

        <h4>The usage of IPT is also demonstrated through the following videos:</h4>
        <h5>OpenMP Version of Molecular Dynamics Code Using the Interactive Parallelization Tool</h5>
        <iframe width="560" height="315" src="https://www.youtube.com/embed/JH7o_k9Bxd0?rel=0" frameborder="0" allowfullscreen></iframe>
        <h5>Interactive Parallelization Tool - Parallelizing Molecular Dynamics with MPI</h5>
        <iframe width="560" height="315" src="https://www.youtube.com/embed/HvlA4pnfFjE?rel=0" frameborder="0" allowfullscreen></iframe>
        <h5>The Interactive Parallelization Tool - Parallelizing the FFT Algorithm with CUDA</h5>
        <iframe width="560" height="315" src="https://www.youtube.com/embed/kCOjqza7OG8?rel=0" frameborder="0" allowfullscreen></iframe>
        <h5>The Interactive Parallelization Tool - Parallelizing the FFT algorithm with OpenMP</h5>
        <iframe width="560" height="315" src="https://www.youtube.com/embed/L4a19kF6q48?rel=0" frameborder="0" allowfullscreen></iframe>
        <h5>The Interactive Parallelization Tool - Parallelizing the FFT algorithm with MPI</h5>
        <iframe width="560" height="315" src="https://www.youtube.com/embed/sg9HDTz0zbo?rel=0" frameborder="0" allowfullscreen></iframe>

      <jsp:include page="footer.jsp" />

</body>
</html>